/**
 * Solution Engine
 * Generates and applies solutions to detected issues
 */

import { debugIssue } from './debugger.js';
import { applyFix } from './fix-applier.js';
import { detectIssues } from './issue-detector.js';

/**
 * Generate solution for issue
 * @param {Object} issue - Issue to solve
 * @param {Object} options - Solution options
 * @returns {Promise<Object>} Solution object
 */
export async function generateSolution(issue, options = {}) {
  const { autoApply = false, requireConfirmation = true } = options;

  // Debug the issue to understand root cause
  const debug = await debugIssue(issue, options);

  // Generate solution based on debug analysis
  const solution = {
    issue: issue,
    debug: debug,
    solution: {
      type: debug.fixStrategy.type,
      steps: debug.fixStrategy.steps,
      automated: debug.fixStrategy.automated,
      confidence: debug.confidence,
      estimatedTime: debug.fixStrategy.estimatedTime,
    },
    apply: null,
  };

  // Apply solution if requested and automated
  if (autoApply && debug.fixStrategy.automated && debug.confidence > 70) {
    if (!requireConfirmation || !debug.fixStrategy.requiresConfirmation) {
      solution.apply = await applyFix(issue, debug.fixStrategy, options);
    }
  }

  return solution;
}

/**
 * Solve all detected issues
 * @param {Object} options - Solution options
 * @returns {Promise<Object>} Solution results
 */
export async function solveAllIssues(options = {}) {
  const {
    autoApply = false,
    requireConfirmation = true,
    // maxConcurrent available for future use
  } = options;

  // Detect all issues
  const issues = await detectIssues(options);

  // Sort by severity (high first)
  const sortedIssues = issues.sort((a, b) => {
    const severityOrder = { high: 3, medium: 2, low: 1 };
    return (severityOrder[b.severity] || 0) - (severityOrder[a.severity] || 0);
  });

  const results = {
    totalIssues: issues.length,
    solved: 0,
    failed: 0,
    skipped: 0,
    solutions: [],
  };

  // Solve each issue
  for (const issue of sortedIssues) {
    try {
      const solution = await generateSolution(issue, {
        autoApply,
        requireConfirmation,
      });

      results.solutions.push(solution);

      if (solution.apply) {
        if (solution.apply.success) {
          results.solved++;
        } else {
          results.failed++;
        }
      } else {
        results.skipped++;
      }

      // Small delay between solutions
      await new Promise((resolve) => setTimeout(resolve, 1000));
    } catch (error) {
      results.failed++;
      results.solutions.push({
        issue: issue,
        error: error.message,
      });
    }
  }

  return results;
}

/**
 * Get solution recommendations
 * @param {Object} issue - Issue
 * @returns {Promise<Array>} Array of solution recommendations
 */
export async function getSolutionRecommendations(issue) {
  const recommendations = [];

  // Generate solution to get recommendations
  const solution = await generateSolution(issue, { autoApply: false });

  // Add solution steps as recommendations
  solution.solution.steps.forEach((step, index) => {
    recommendations.push({
      order: index + 1,
      action: step,
      automated: solution.solution.automated,
      confidence: solution.solution.confidence,
    });
  });

  // Add alternative solutions if confidence is low
  if (solution.solution.confidence < 70) {
    recommendations.push({
      order: 999,
      action: 'Manual investigation recommended',
      automated: false,
      confidence: 0,
      reason: 'Low confidence in automated solution',
    });
  }

  return recommendations;
}
