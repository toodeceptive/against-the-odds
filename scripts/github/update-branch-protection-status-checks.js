#!/usr/bin/env node
/* eslint-disable no-console */
/**
 * Set required status checks for main branch to CI-only (test, secret-scan, quality).
 * Token: GITHUB_TOKEN or GH_TOKEN env, .env.local, or Git credential for github.com.
 * Usage: node scripts/github/update-branch-protection-status-checks.js
 */
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const OWNER = 'toodeceptive';
const REPO = 'against-the-odds';
const BRANCH = 'main';
const CI_CONTEXTS = ['test', 'secret-scan', 'quality'];

function tokenFromGitCredential() {
  try {
    const input = 'protocol=https\nhost=github.com\n';
    const out = execSync('git credential fill', {
      encoding: 'utf8',
      input,
      env: { ...process.env, GIT_TERMINAL_PROMPT: '0' },
    });
    const match = out.match(/password=(.+)/m);
    if (match && match[1].trim()) return match[1].trim();
  } catch (_) {
    // no credential or git not available
  }
  return null;
}

function loadToken() {
  for (const name of ['GITHUB_TOKEN', 'GH_TOKEN']) {
    const v = process.env[name] && process.env[name].trim();
    if (v && v !== 'your_github_personal_access_token_here') return v;
  }
  const root = path.resolve(__dirname, '..', '..');
  const envPath = path.join(root, '.env.local');
  if (fs.existsSync(envPath)) {
    const content = fs.readFileSync(envPath, 'utf8');
    for (const line of content.split('\n')) {
      const m = line.match(/^\s*GITHUB_TOKEN\s*=\s*(.+)\s*$/);
      if (m) {
        const token = m[1].trim().replace(/^["']|["']$/g, '');
        if (token && token !== 'your_github_personal_access_token_here') return token;
        break;
      }
    }
  }
  const fromGit = tokenFromGitCredential();
  if (fromGit) return fromGit;
  console.error(
    'No GitHub token found. Set GITHUB_TOKEN, add to .env.local, or ensure Git has credentials for github.com.'
  );
  process.exit(1);
}

async function setStatusCheckContexts(token) {
  const url = `https://api.github.com/repos/${OWNER}/${REPO}/branches/${BRANCH}/protection/required_status_checks`;
  const res = await fetch(url, {
    method: 'PATCH',
    headers: {
      Accept: 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      Authorization: `Bearer ${token}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ strict: true, contexts: CI_CONTEXTS }),
  });
  if (!res.ok) {
    const text = await res.text();
    if (res.status === 404) {
      console.error(
        'Branch protection not found for main. Enable it in GitHub Settings > Branches first.'
      );
    } else {
      console.error(`GitHub API ${res.status}: ${text}`);
    }
    process.exit(1);
  }
  const data = await res.json();
  console.log('Required status checks updated:', data.contexts || CI_CONTEXTS);
}

(async () => {
  const token = loadToken();
  await setStatusCheckContexts(token);
})();
