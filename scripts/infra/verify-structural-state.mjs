import { createHash } from 'crypto';
import { readFileSync } from 'fs';
import { resolve } from 'path';

const repoRoot = resolve(new URL('../../', import.meta.url).pathname);
const structuralFilesPath = resolve(repoRoot, 'infra', 'STRUCTURAL_FILES.json');
const structuralStatePath = resolve(repoRoot, 'infra', 'STRUCTURAL_STATE.json');

function hashFile(path) {
  return createHash('sha256').update(readFileSync(path)).digest('hex');
}

function fail(message) {
  process.stderr.write(`::error::${message}\n`);
  process.exit(1);
}

const structuralFiles = JSON.parse(readFileSync(structuralFilesPath, 'utf8')).files.sort();
const structuralState = JSON.parse(readFileSync(structuralStatePath, 'utf8'));
const stateFiles = Object.keys(structuralState.files || {}).sort();

if (JSON.stringify(structuralFiles) !== JSON.stringify(stateFiles)) {
  fail(
    `STRUCTURAL_STATE.json file list mismatch. Expected ${structuralFiles.join(', ')}, found ${stateFiles.join(', ')}. Regenerate the structural state.`
  );
}

for (const relPath of structuralFiles) {
  const absolutePath = resolve(repoRoot, relPath);
  const expectedHash = structuralState.files[relPath];
  const actualHash = hashFile(absolutePath);
  if (actualHash !== expectedHash) {
    fail(
      `Structural file hash mismatch for ${relPath}. Expected ${expectedHash}, found ${actualHash}. Run scripts/infra/sign-structural-state.(ps1|sh).`
    );
  }
}

process.stdout.write('Structural state matches signed file hashes.\n');
