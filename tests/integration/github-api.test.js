import { describe, it, expect } from 'vitest';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

function loadEnv() {
  try {
    const envPath = join(__dirname, '../../.env.local');
    const envContent = readFileSync(envPath, 'utf-8');
    const envVars = {};

    envContent.split('\n').forEach((line) => {
      const match = line.match(/^([A-Z_]+)=(.+)$/);
      if (match && !line.startsWith('#')) {
        envVars[match[1]] = match[2].trim();
      }
    });

    return envVars;
  } catch (error) {
    return {};
  }
}

describe('GitHub API Integration', () => {
  const envVars = loadEnv();
  const githubToken = envVars.GITHUB_TOKEN || process.env.GITHUB_TOKEN;
  const githubUsername = envVars.GITHUB_USERNAME || process.env.GITHUB_USERNAME || 'toodeceptive';
  const githubRepo = envVars.GITHUB_REPO || process.env.GITHUB_REPO || 'against-the-odds';
  const hasGithubToken = Boolean(githubToken);

  const itIf = (condition) => (condition ? it : it.skip);

  itIf(hasGithubToken)('should have GitHub token configured', () => {
    expect(githubToken).toBeDefined();
    expect(githubToken).not.toBe('');
  });

  itIf(hasGithubToken)('should connect to GitHub API', async () => {
    const response = await fetch('https://api.github.com/user', {
      headers: {
        Authorization: `token ${githubToken}`,
        Accept: 'application/vnd.github.v3+json',
      },
    });

    expect(response.ok).toBe(true);
    const data = await response.json();
    expect(data.login).toBeDefined();
  });

  itIf(hasGithubToken)('should access repository', async () => {
    const response = await fetch(`https://api.github.com/repos/${githubUsername}/${githubRepo}`, {
      headers: {
        Authorization: `token ${githubToken}`,
        Accept: 'application/vnd.github.v3+json',
      },
    });

    expect(response.ok).toBe(true);
    const data = await response.json();
    expect(data.name).toBe(githubRepo);
    expect(data.owner.login).toBe(githubUsername);
  });

  itIf(hasGithubToken)('should list repository branches', async () => {
    const response = await fetch(
      `https://api.github.com/repos/${githubUsername}/${githubRepo}/branches`,
      {
        headers: {
          Authorization: `token ${githubToken}`,
          Accept: 'application/vnd.github.v3+json',
        },
      }
    );

    expect(response.ok).toBe(true);
    const data = await response.json();
    expect(Array.isArray(data)).toBe(true);
    expect(data.length).toBeGreaterThan(0);
  });
});
