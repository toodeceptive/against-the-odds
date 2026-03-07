#!/usr/bin/env node
/* eslint-disable no-console */
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const OWNER = 'toodeceptive';
const REPO = 'against-the-odds';
const BRANCH = 'main';
const REQUIRED_CONTEXTS = ['arch_guard', 'test', 'secret-scan', 'e2e_smoke', 'quality'].sort();

function tokenFromGitCredential() {
  try {
    const input = 'protocol=https\nhost=github.com\n';
    const out = execSync('git credential fill', {
      encoding: 'utf8',
      input,
      env: { ...process.env, GIT_TERMINAL_PROMPT: '0' },
      stdio: ['pipe', 'pipe', 'ignore'],
    });
    const match = out.match(/password=(.+)/m);
    if (match && match[1].trim()) return match[1].trim();
  } catch (_) {
    // Ignore missing credential.
  }
  return null;
}

function loadToken() {
  for (const name of ['GITHUB_ADMIN_TOKEN', 'GITHUB_TOKEN', 'GH_TOKEN']) {
    const value = process.env[name] && process.env[name].trim();
    if (
      value &&
      value !== 'your_github_personal_access_token_here' &&
      value !== 'your_github_admin_token_here'
    ) {
      return value;
    }
  }

  const root = path.resolve(__dirname, '..', '..');
  const envPath = path.join(root, '.env.local');
  if (fs.existsSync(envPath)) {
    const content = fs.readFileSync(envPath, 'utf8');
    for (const key of ['GITHUB_ADMIN_TOKEN', 'GITHUB_TOKEN']) {
      for (const line of content.split('\n')) {
        const match = line.match(new RegExp(`^\\s*${key}\\s*=\\s*(.+)\\s*$`));
        if (match) {
          const token = match[1].trim().replace(/^["']|["']$/g, '');
          if (
            token &&
            token !== 'your_github_personal_access_token_here' &&
            token !== 'your_github_admin_token_here'
          ) {
            return token;
          }
          break;
        }
      }
    }
  }

  return tokenFromGitCredential();
}

function addFailure(failures, message) {
  failures.push(message);
}

function compareContexts(actualContexts, failures) {
  const actual = [...actualContexts].sort();
  if (JSON.stringify(actual) !== JSON.stringify(REQUIRED_CONTEXTS)) {
    addFailure(
      failures,
      `Required status checks mismatch. Expected [${REQUIRED_CONTEXTS.join(', ')}], found [${actual.join(', ')}].`
    );
  }
}

async function fetchJson(url, token) {
  const response = await fetch(url, {
    headers: {
      Accept: 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      Authorization: `Bearer ${token}`,
    },
  });

  if (!response.ok) {
    const body = await response.text();
    const error = new Error(`GitHub API ${response.status}: ${body}`);
    error.status = response.status;
    throw error;
  }

  return response.json();
}

async function main() {
  const token = loadToken();
  if (!token) {
    console.error(
      'No GitHub admin-capable token found. Set GITHUB_ADMIN_TOKEN (preferred), GITHUB_TOKEN, or GH_TOKEN.'
    );
    process.exit(1);
  }

  const protectionUrl = `https://api.github.com/repos/${OWNER}/${REPO}/branches/${BRANCH}/protection`;
  let protection;

  try {
    protection = await fetchJson(protectionUrl, token);
  } catch (error) {
    if (error.status === 403) {
      console.error(
        'Governance verification needs an admin-capable token. The current credential cannot read branch protection.'
      );
    } else if (error.status === 404) {
      console.error('Branch protection for main is not configured.');
    } else {
      console.error(error.message);
    }
    process.exit(1);
  }

  const failures = [];

  const requiredStatusChecks = protection.required_status_checks;
  if (!requiredStatusChecks) {
    addFailure(failures, 'Required status checks are not enabled.');
  } else {
    if (requiredStatusChecks.strict !== true) {
      addFailure(
        failures,
        'Branch protection must require branches to be up to date before merging.'
      );
    }
    compareContexts(requiredStatusChecks.contexts || [], failures);
  }

  if (!protection.enforce_admins?.enabled) {
    addFailure(failures, 'Include administrators must be enabled.');
  }

  const reviewRules = protection.required_pull_request_reviews;
  if (!reviewRules) {
    addFailure(failures, 'Pull request review requirements are not enabled.');
  } else {
    if ((reviewRules.required_approving_review_count || 0) < 1) {
      addFailure(failures, 'At least one approving review is required.');
    }
    if (reviewRules.dismiss_stale_reviews !== true) {
      addFailure(failures, 'Dismiss stale pull request approvals must be enabled.');
    }
    if (reviewRules.require_code_owner_reviews !== true) {
      addFailure(failures, 'Code owner reviews must be required.');
    }
  }

  if (!protection.required_conversation_resolution?.enabled) {
    addFailure(failures, 'Conversation resolution must be required before merging.');
  }

  if (failures.length > 0) {
    for (const failure of failures) {
      console.error(`- ${failure}`);
    }
    process.exit(1);
  }

  console.log(
    `Governance settings verified for ${OWNER}/${REPO}:${BRANCH} (${REQUIRED_CONTEXTS.join(', ')}).`
  );
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
