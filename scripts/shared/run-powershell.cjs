const { spawnSync } = require('node:child_process');
const path = require('node:path');

const [, , scriptPathArg, ...forwardedArgs] = process.argv;
const writeError = (message) => process.stderr.write(`${message}\n`);

if (!scriptPathArg) {
  writeError('Usage: node scripts/shared/run-powershell.cjs <script.ps1> [args...]');
  process.exit(1);
}

const scriptPath = path.resolve(process.cwd(), scriptPathArg);
const candidates = process.platform === 'win32' ? ['powershell', 'pwsh'] : ['pwsh', 'powershell'];

for (const command of candidates) {
  const result = spawnSync(
    command,
    ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', scriptPath, ...forwardedArgs],
    {
      stdio: 'inherit',
      windowsHide: true,
    }
  );

  if (result.error) {
    if (result.error.code === 'ENOENT') {
      continue;
    }

    writeError(`Failed to run ${command}: ${result.error.message}`);
    process.exit(result.status ?? 1);
  }

  process.exit(result.status ?? 0);
}

writeError('Unable to find a PowerShell executable. Install pwsh or powershell and retry.');
process.exit(1);
