import { execFileSync } from 'child_process';
import { readFileSync, readdirSync } from 'fs';
import { resolve } from 'path';

const repoRoot = resolve(new URL('../../', import.meta.url).pathname);
const versionPolicyPath = resolve(repoRoot, 'docs', 'VERSION_POLICY.md');
const productDir = resolve(repoRoot, 'data', 'products');

function git(args, options = {}) {
  return execFileSync('git', args, {
    cwd: repoRoot,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
    ...options,
  }).trim();
}

function parseCurrentProductVersion(markdown) {
  const match = markdown.match(/- \*\*data\/products\*\* — `(\d+)`/);
  if (!match) {
    throw new Error(
      'Could not parse current data/products schema version from docs/VERSION_POLICY.md'
    );
  }
  return Number(match[1]);
}

function readJson(path) {
  return JSON.parse(readFileSync(path, 'utf8'));
}

function getChangedFiles(baseRef) {
  const changed = new Set();

  if (baseRef) {
    const committed = git([
      'diff',
      '--name-only',
      `${baseRef}...HEAD`,
      '--',
      'data/products',
      'docs/VERSION_POLICY.md',
    ]);
    committed
      .split('\n')
      .map((file) => file.trim())
      .filter(Boolean)
      .forEach((file) => changed.add(file));
  }

  for (const args of [
    ['diff', '--name-only', '--', 'data/products', 'docs/VERSION_POLICY.md'],
    ['diff', '--cached', '--name-only', '--', 'data/products', 'docs/VERSION_POLICY.md'],
  ]) {
    const output = git(args);
    output
      .split('\n')
      .map((file) => file.trim())
      .filter(Boolean)
      .forEach((file) => changed.add(file));
  }

  return Array.from(changed);
}

function getBaseRef() {
  if (process.env.GITHUB_EVENT_NAME === 'pull_request' && process.env.GITHUB_BASE_REF) {
    return git(['merge-base', 'HEAD', `origin/${process.env.GITHUB_BASE_REF}`]);
  }

  try {
    return git(['rev-parse', 'HEAD^']);
  } catch {
    return null;
  }
}

function getJsonFromGit(baseRef, relPath) {
  try {
    return JSON.parse(git(['show', `${baseRef}:${relPath}`]));
  } catch {
    return null;
  }
}

function getTextFromGit(baseRef, relPath) {
  try {
    return git(['show', `${baseRef}:${relPath}`]);
  } catch {
    return null;
  }
}

function compareTopLevelContract(beforeJson, afterJson) {
  const beforeKeys = Object.keys(beforeJson)
    .filter((key) => key !== 'schema_version')
    .sort();
  const afterKeys = Object.keys(afterJson)
    .filter((key) => key !== 'schema_version')
    .sort();
  return JSON.stringify(beforeKeys) !== JSON.stringify(afterKeys);
}

function fail(message) {
  process.stderr.write(`::error::${message}\n`);
  process.exit(1);
}

const currentVersion = parseCurrentProductVersion(readFileSync(versionPolicyPath, 'utf8'));
const currentProductFiles = readdirSync(productDir)
  .filter((entry) => entry.endsWith('.json'))
  .map((entry) => `data/products/${entry}`)
  .sort();

for (const relPath of currentProductFiles) {
  const product = readJson(resolve(repoRoot, relPath));
  if (typeof product.schema_version !== 'number') {
    fail(`${relPath} is missing a numeric schema_version.`);
  }
  if (product.schema_version !== currentVersion) {
    fail(
      `${relPath} schema_version=${product.schema_version} does not match docs/VERSION_POLICY.md current version ${currentVersion}.`
    );
  }
}

const baseRef = getBaseRef();
if (!baseRef) {
  process.stdout.write('No base ref available; schema presence/version checks passed.\n');
  process.exit(0);
}

const changedFiles = getChangedFiles(baseRef);
const changedProductFiles = changedFiles.filter(
  (file) => file.startsWith('data/products/') && file.endsWith('.json')
);
if (changedProductFiles.length === 0) {
  process.stdout.write('No product schema changes detected.\n');
  process.exit(0);
}

const previousPolicy = getTextFromGit(baseRef, 'docs/VERSION_POLICY.md');
const previousVersion = previousPolicy ? parseCurrentProductVersion(previousPolicy) : null;
const versionPolicyChanged = previousVersion !== null && previousVersion !== currentVersion;

for (const relPath of changedProductFiles) {
  const currentJson = readJson(resolve(repoRoot, relPath));
  const previousJson = getJsonFromGit(baseRef, relPath);
  if (!previousJson) continue;

  const contractChanged = compareTopLevelContract(previousJson, currentJson);
  const fileVersionChanged = previousJson.schema_version !== currentJson.schema_version;
  if (contractChanged && !fileVersionChanged && !versionPolicyChanged) {
    fail(
      `Top-level product contract changed in ${relPath} without a schema version bump. Update schema_version or docs/VERSION_POLICY.md.`
    );
  }
}

process.stdout.write('Product schema version checks passed.\n');
