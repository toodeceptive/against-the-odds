import { execFileSync } from 'child_process';
import { resolve } from 'path';

const repoRoot = resolve(new URL('../../', import.meta.url).pathname);
const themePrefix = 'src/shopify/themes/aodrop-theme';
const requiredFiles = ['layout/theme.liquid', 'config/settings_data.json'];

function git(args) {
  return execFileSync('git', args, {
    cwd: repoRoot,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
  }).trim();
}

function fail(message) {
  process.stderr.write(`::error::${message}\n`);
  process.exit(1);
}

function branchExists(name) {
  try {
    git(['show-ref', '--verify', '--quiet', `refs/heads/${name}`]);
    return true;
  } catch {
    return false;
  }
}

const tempBranch = 'verify-shopify-theme-branch';
const hadExistingTempBranch = branchExists(tempBranch);

try {
  const splitSha = git(['subtree', 'split', `--prefix=${themePrefix}`]);
  if (!splitSha) {
    fail(`git subtree split returned no commit for ${themePrefix}.`);
  }

  const files = git(['ls-tree', '-r', '--name-only', splitSha])
    .split('\n')
    .map((file) => file.trim())
    .filter(Boolean);

  if (files.length === 0) {
    fail(`Theme export for ${themePrefix} is empty.`);
  }

  const prefixedEntries = files.filter((file) => file.startsWith(`${themePrefix}/`));
  if (prefixedEntries.length > 0) {
    fail(`Theme subtree export still contains ${themePrefix}/ prefixes. Export root is invalid.`);
  }

  for (const requiredFile of requiredFiles) {
    if (!files.includes(requiredFile)) {
      fail(`Theme export is missing required file ${requiredFile}.`);
    }
  }

  process.stdout.write(
    `Theme branch export verified (${splitSha.slice(0, 12)}): ${requiredFiles.join(', ')} present.\n`
  );
} finally {
  if (!hadExistingTempBranch && branchExists(tempBranch)) {
    try {
      git(['branch', '-D', tempBranch]);
    } catch {
      // Ignore cleanup failure; verifier already emitted the primary error if any.
    }
  }
}
