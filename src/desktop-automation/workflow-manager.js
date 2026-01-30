/**
 * Workflow Manager
 * Manages automation workflows and task sequences
 */

import { executeTasksSequential, executeTasksParallel } from './task-executor.js';

/**
 * Workflow definition
 */
export class Workflow {
  constructor(name, steps) {
    this.name = name;
    this.steps = steps;
    this.status = 'pending';
    this.results = [];
  }

  /**
   * Execute workflow
   * @param {Object} options - Execution options
   * @returns {Promise<Object>} Workflow result
   */
  async execute(options = {}) {
    this.status = 'running';

    try {
      if (options.parallel) {
        this.results = await executeTasksParallel(this.steps, options);
      } else {
        this.results = await executeTasksSequential(this.steps, options);
      }

      const allSuccess = this.results.every((r) => r.success);
      this.status = allSuccess ? 'completed' : 'failed';

      return {
        workflow: this.name,
        status: this.status,
        results: this.results,
        success: allSuccess,
      };
    } catch (error) {
      this.status = 'error';
      return {
        workflow: this.name,
        status: 'error',
        error: error.message,
        results: this.results,
      };
    }
  }
}

/**
 * Predefined workflows
 */
export const Workflows = {
  /**
   * Complete system health check workflow
   */
  healthCheck: new Workflow('health_check', [
    async () => {
      const { analyzeScreen } = await import('./screen-analyzer.js');
      return await analyzeScreen();
    },
    async () => {
      const { detectIssues } = await import('./issue-detector.js');
      return await detectIssues();
    },
    async () => {
      const { execSync } = await import('child_process');
      execSync('powershell -ExecutionPolicy Bypass -File scripts/health/comprehensive-check.ps1');
      return { success: true };
    },
  ]),

  /**
   * Issue detection and resolution workflow
   */
  detectAndFix: new Workflow('detect_and_fix', [
    async () => {
      const { detectIssues } = await import('./issue-detector.js');
      return await detectIssues();
    },
    async () => {
      const { solveAllIssues } = await import('./solution-engine.js');
      return await solveAllIssues({ autoApply: true, requireConfirmation: true });
    },
  ]),

  /**
   * Environment setup workflow
   */
  environmentSetup: new Workflow('environment_setup', [
    async () => {
      const { execSync } = await import('child_process');
      execSync('powershell -ExecutionPolicy Bypass -File scripts/setup/auto-configure-env.ps1');
      return { success: true };
    },
    async () => {
      const { execSync } = await import('child_process');
      execSync('powershell -ExecutionPolicy Bypass -File scripts/setup/verify-credentials.ps1');
      return { success: true };
    },
  ]),
};

/**
 * Execute workflow by name
 * @param {string} workflowName - Workflow name
 * @param {Object} options - Execution options
 * @returns {Promise<Object>} Workflow result
 */
export async function executeWorkflow(workflowName, options = {}) {
  const workflow = Workflows[workflowName];

  if (!workflow) {
    throw new Error(`Workflow not found: ${workflowName}`);
  }

  return await workflow.execute(options);
}

/**
 * Create custom workflow
 * @param {string} name - Workflow name
 * @param {Array<Function>} steps - Workflow steps
 * @returns {Workflow} Workflow instance
 */
export function createWorkflow(name, steps) {
  return new Workflow(name, steps);
}
