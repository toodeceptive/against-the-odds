import { execFileSync } from 'child_process';
import { readFileSync, readdirSync } from 'fs';
import { resolve } from 'path';

const repoRoot = resolve(new URL('../../', import.meta.url).pathname);
const versionPolicyPath = resolve(repoRoot, 'docs', 'VERSION_POLICY.md');

const SCHEMA_AREAS = [
  {
    name: 'products',
    dir: resolve(repoRoot, 'data', 'products'),
    prefix: 'data/products/',
    versionPattern: /- \*\*data\/products\*\* — `(\d+)`/,
    requiredFields: [
      {
        key: 'handle',
        validate(value, relPath, fail) {
          if (typeof value !== 'string' || !value.trim()) {
            fail(`${relPath} is missing a non-empty handle.`);
          }
          if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(value.trim())) {
            fail(
              `${relPath} handle="${value}" is invalid. Use lowercase letters, numbers, and hyphens only.`
            );
          }
        },
      },
    ],
  },
  {
    name: 'manufacturers',
    dir: resolve(repoRoot, 'data', 'manufacturers'),
    prefix: 'data/manufacturers/',
    versionPattern: /- \*\*data\/manufacturers\*\* — `(\d+)`/,
    requiredFields: [],
  },
];

function git(args, options = {}) {
  return execFileSync('git', args, {
    cwd: repoRoot,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
    ...options,
  }).trim();
}

function readJson(path) {
  return JSON.parse(readFileSync(path, 'utf8'));
}

function fail(message) {
  process.stderr.write(`::error::${message}\n`);
  process.exit(1);
}

function parseDeclaredVersion(markdown, pattern, areaName) {
  const match = markdown.match(pattern);
  if (!match) {
    throw new Error(
      `Could not parse current ${areaName} schema version from docs/VERSION_POLICY.md`
    );
  }
  return Number(match[1]);
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

function getChangedFiles(baseRef, areas) {
  const changed = new Set();
  const scopedPaths = [
    ...areas.map((area) => area.prefix.replace(/\/$/, '')),
    'docs/VERSION_POLICY.md',
  ];

  if (baseRef) {
    const committed = git(['diff', '--name-only', `${baseRef}...HEAD`, '--', ...scopedPaths]);
    committed
      .split('\n')
      .map((file) => file.trim())
      .filter(Boolean)
      .forEach((file) => changed.add(file));
  }

  for (const args of [
    ['diff', '--name-only', '--', ...scopedPaths],
    ['diff', '--cached', '--name-only', '--', ...scopedPaths],
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

const versionPolicy = readFileSync(versionPolicyPath, 'utf8');
const areaVersions = new Map(
  SCHEMA_AREAS.map((area) => [
    area.name,
    parseDeclaredVersion(versionPolicy, area.versionPattern, area.name),
  ])
);

for (const area of SCHEMA_AREAS) {
  const currentFiles = readdirSync(area.dir)
    .filter((entry) => entry.endsWith('.json'))
    .map((entry) => `${area.prefix}${entry}`)
    .sort();

  for (const relPath of currentFiles) {
    const document = readJson(resolve(repoRoot, relPath));
    if (typeof document.schema_version !== 'number') {
      fail(`${relPath} is missing a numeric schema_version.`);
    }
    if (document.schema_version !== areaVersions.get(area.name)) {
      fail(
        `${relPath} schema_version=${document.schema_version} does not match docs/VERSION_POLICY.md current ${area.name} version ${areaVersions.get(area.name)}.`
      );
    }
    for (const requiredField of area.requiredFields) {
      requiredField.validate(document[requiredField.key], relPath, fail);
    }
  }
}

const baseRef = getBaseRef();
if (!baseRef) {
  process.stdout.write('No base ref available; schema presence/version checks passed.\n');
  process.exit(0);
}

const changedFiles = getChangedFiles(baseRef, SCHEMA_AREAS);
const previousPolicy = getTextFromGit(baseRef, 'docs/VERSION_POLICY.md');

for (const area of SCHEMA_AREAS) {
  const changedAreaFiles = changedFiles.filter(
    (file) => file.startsWith(area.prefix) && file.endsWith('.json')
  );
  if (changedAreaFiles.length === 0) {
    continue;
  }

  const previousVersion = previousPolicy
    ? parseDeclaredVersion(previousPolicy, area.versionPattern, area.name)
    : null;
  const versionPolicyChanged =
    previousVersion !== null && previousVersion !== areaVersions.get(area.name);

  for (const relPath of changedAreaFiles) {
    const currentJson = readJson(resolve(repoRoot, relPath));
    const previousJson = getJsonFromGit(baseRef, relPath);
    if (!previousJson) continue;

    const contractChanged = compareTopLevelContract(previousJson, currentJson);
    const fileVersionChanged = previousJson.schema_version !== currentJson.schema_version;
    if (contractChanged && !fileVersionChanged && !versionPolicyChanged) {
      fail(
        `Top-level ${area.name} contract changed in ${relPath} without a schema version bump. Update schema_version or docs/VERSION_POLICY.md.`
      );
    }
  }
}

process.stdout.write('Data schema version checks passed.\n');
