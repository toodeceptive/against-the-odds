/**
 * Automation Orchestrator
 * Coordinates all desktop automation components
 */

import { detectIssues } from './issue-detector.js';
import { generateSolution, solveAllIssues } from './solution-engine.js';
import { analyzeScreen } from './screen-analyzer.js';
import { requiresConfirmation, canProceed, setEmergencyStop } from './safety-manager.js';
import { requestConfirmation } from './confirmation-system.js';
import { info, error, warn, logAction } from './logger.js';

/**
 * Main orchestrator class
 */
export class AutomationOrchestrator {
  constructor(options = {}) {
    this.options = {
      autoDetect: options.autoDetect !== false,
      autoFix: options.autoFix || false,
      requireConfirmation: options.requireConfirmation !== false,
      monitoring: options.monitoring || false,
      monitoringInterval: options.monitoringInterval || 10000,
      ...options,
    };

    this.isRunning = false;
    this.monitoringInterval = null;
    this.actionLog = [];
  }

  /**
   * Start automation orchestrator
   * @returns {Promise<void>}
   */
  async start() {
    if (this.isRunning) {
      info('Orchestrator already running');
      return;
    }

    this.isRunning = true;
    info('Automation orchestrator started');

    // Start monitoring if enabled
    if (this.options.monitoring) {
      this.startMonitoring();
    }

    // Initial detection and fixing
    if (this.options.autoDetect) {
      await this.detectAndFix();
    }
  }

  /**
   * Stop automation orchestrator
   */
  stop() {
    this.isRunning = false;

    if (this.monitoringInterval) {
      clearInterval(this.monitoringInterval);
      this.monitoringInterval = null;
    }

    info('Automation orchestrator stopped');
  }

  /**
   * Detect and fix issues
   * @returns {Promise<Object>} Detection and fix results
   */
  async detectAndFix() {
    if (!canProceed()) {
      warn('Emergency stop active - cannot proceed');
      return { detected: 0, fixed: 0, blocked: true };
    }

    logAction('detect_and_fix', 'Starting issue detection and fixing');

    // Detect issues
    const issues = await detectIssues(this.options);
    this.logAction('detect', `Detected ${issues.length} issues`);

    if (issues.length === 0) {
      return { detected: 0, fixed: 0, issues: [] };
    }

    // Solve issues
    let results = { detected: issues.length, fixed: 0, issues: [] };

    if (this.options.autoFix) {
      results = await solveAllIssues({
        autoApply: true,
        requireConfirmation: this.options.requireConfirmation,
      });
    } else {
      // Just generate solutions without applying
      for (const issue of issues) {
        const solution = await generateSolution(issue, { autoApply: false });
        results.issues.push(solution);
      }
    }

    this.logAction('fix', `Fixed ${results.solved} issues`);

    return results;
  }

  /**
   * Start continuous monitoring
   */
  startMonitoring() {
    this.monitoringInterval = setInterval(async () => {
      if (!this.isRunning || !canProceed()) {
        return;
      }

      try {
        await this.detectAndFix();
      } catch (err) {
        error('Monitoring error', err);
      }
    }, this.options.monitoringInterval);
  }

  /**
   * Execute task
   * @param {string} task - Task name
   * @param {Object} params - Task parameters
   * @returns {Promise<Object>} Task result
   */
  async executeTask(task, params = {}) {
    if (!canProceed()) {
      throw new Error('Emergency stop active');
    }

    this.logAction('execute_task', task, params);

    // Check if confirmation required
    if (requiresConfirmation(task)) {
      const confirmed = await requestConfirmation(task, params);
      if (!confirmed) {
        return { success: false, reason: 'Not confirmed' };
      }
    }

    // Execute task based on type
    switch (task) {
      case 'detect_issues':
        return await this.detectAndFix();

      case 'analyze_screen':
        return await analyzeScreen(params);

      case 'fix_issue': {
        const { issue } = params;
        const solution = await generateSolution(issue, { autoApply: true });
        return solution;
      }

      default:
        throw new Error(`Unknown task: ${task}`);
    }
  }

  /**
   * Log action
   * @param {string} type - Action type
   * @param {string} description - Action description
   * @param {Object} data - Additional data
   */
  logAction(type, description, data = {}) {
    const logEntry = {
      timestamp: new Date().toISOString(),
      type: type,
      description: description,
      data: data,
    };

    this.actionLog.push(logEntry);
    logAction(type, description, data);
  }

  /**
   * Get action log
   * @returns {Array} Action log
   */
  getActionLog() {
    return this.actionLog;
  }

  /**
   * Clear action log
   */
  clearActionLog() {
    this.actionLog = [];
  }

  /**
   * Emergency stop
   */
  emergencyStop() {
    setEmergencyStop(true);
    this.stop();
    error('EMERGENCY STOP ACTIVATED');
  }

  /**
   * Resume after emergency stop
   */
  resume() {
    setEmergencyStop(false);
    info('Resuming operations');
  }
}

/**
 * Create orchestrator instance
 * @param {Object} options - Orchestrator options
 * @returns {AutomationOrchestrator} Orchestrator instance
 */
export function createOrchestrator(options = {}) {
  return new AutomationOrchestrator(options);
}
