import { describe, it, expect, beforeAll } from 'vitest';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

describe('GitHub API Integration', () => {
  let githubToken;
  let githubUsername;
  let githubRepo;
  
  beforeAll(() => {
    // Load environment variables from .env.local if it exists
    try {
      const envPath = join(__dirname, '../../.env.local');
      const envContent = readFileSync(envPath, 'utf-8');
      const envVars = {};
      
      envContent.split('\n').forEach(line => {
        const match = line.match(/^([A-Z_]+)=(.+)$/);
        if (match && !line.startsWith('#')) {
          envVars[match[1]] = match[2].trim();
        }
      });
      
      githubToken = envVars.GITHUB_TOKEN || process.env.GITHUB_TOKEN;
      githubUsername = envVars.GITHUB_USERNAME || process.env.GITHUB_USERNAME || 'toodeceptive';
      githubRepo = envVars.GITHUB_REPO || process.env.GITHUB_REPO || 'against-the-odds';
    } catch (error) {
      // .env.local not found, use process.env
      githubToken = process.env.GITHUB_TOKEN;
      githubUsername = process.env.GITHUB_USERNAME || 'toodeceptive';
      githubRepo = process.env.GITHUB_REPO || 'against-the-odds';
    }
  });
  
  it('should have GitHub token configured', () => {
    if (!githubToken) {
      console.log('Skipping: GITHUB_TOKEN not configured');
      return;
    }
    expect(githubToken).toBeDefined();
    expect(githubToken).not.toBe('');
  });
  
  it('should connect to GitHub API', async () => {
    if (!githubToken) {
      console.log('Skipping: GITHUB_TOKEN not configured');
      return;
    }
    
    const response = await fetch('https://api.github.com/user', {
      headers: {
        'Authorization': `token ${githubToken}`,
        'Accept': 'application/vnd.github.v3+json',
      },
    });
    
    expect(response.ok).toBe(true);
    const data = await response.json();
    expect(data.login).toBeDefined();
  });
  
  it('should access repository', async () => {
    if (!githubToken) {
      console.log('Skipping: GITHUB_TOKEN not configured');
      return;
    }
    
    const response = await fetch(
      `https://api.github.com/repos/${githubUsername}/${githubRepo}`,
      {
        headers: {
          'Authorization': `token ${githubToken}`,
          'Accept': 'application/vnd.github.v3+json',
        },
      }
    );
    
    expect(response.ok).toBe(true);
    const data = await response.json();
    expect(data.name).toBe(githubRepo);
    expect(data.owner.login).toBe(githubUsername);
  });
  
  it('should list repository branches', async () => {
    if (!githubToken) {
      console.log('Skipping: GITHUB_TOKEN not configured');
      return;
    }
    
    const response = await fetch(
      `https://api.github.com/repos/${githubUsername}/${githubRepo}/branches`,
      {
        headers: {
          'Authorization': `token ${githubToken}`,
          'Accept': 'application/vnd.github.v3+json',
        },
      }
    );
    
    expect(response.ok).toBe(true);
    const data = await response.json();
    expect(Array.isArray(data)).toBe(true);
    expect(data.length).toBeGreaterThan(0);
  });
});
