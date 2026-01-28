/**
 * State Comparator
 * Compares screen states to detect changes and issues
 */

import { analyzeScreen } from './screen-analyzer.js';

/**
 * Screen state snapshot
 */
export class ScreenState {
  constructor(analysis) {
    this.timestamp = analysis.timestamp;
    this.text = analysis.text;
    this.elements = analysis.elements;
    this.issues = analysis.issues;
    this.dimensions = analysis.dimensions;
    this.ocrConfidence = analysis.ocrConfidence;
  }

  /**
   * Create state from current screen
   * @returns {Promise<ScreenState>} Screen state
   */
  static async capture() {
    const analysis = await analyzeScreen();
    return new ScreenState(analysis);
  }
}

/**
 * Compare two screen states
 * @param {ScreenState} state1 - First state
 * @param {ScreenState} state2 - Second state
 * @returns {Object} Comparison result
 */
export function compareStates(state1, state2) {
  const comparison = {
    timestamp: new Date().toISOString(),
    timeDiff: new Date(state2.timestamp) - new Date(state1.timestamp),
    changes: {
      textChanged: state1.text !== state2.text,
      textDiff: calculateTextDiff(state1.text, state2.text),
      elementsChanged: JSON.stringify(state1.elements) !== JSON.stringify(state2.elements),
      issuesChanged: state1.issues.length !== state2.issues.length
    },
    issues: {
      newIssues: state2.issues.filter(issue2 =>
        !state1.issues.some(issue1 => issue1.message === issue2.message)
      ),
      resolvedIssues: state1.issues.filter(issue1 =>
        !state2.issues.some(issue2 => issue2.message === issue1.message)
      ),
      persistentIssues: state1.issues.filter(issue1 =>
        state2.issues.some(issue2 => issue2.message === issue1.message)
      )
    },
    summary: {
      hasChanges: false,
      hasNewIssues: false,
      hasResolvedIssues: false
    }
  };

  // Calculate summary
  comparison.summary.hasChanges = 
    comparison.changes.textChanged || 
    comparison.changes.elementsChanged ||
    comparison.changes.issuesChanged;
  
  comparison.summary.hasNewIssues = comparison.issues.newIssues.length > 0;
  comparison.summary.hasResolvedIssues = comparison.issues.resolvedIssues.length > 0;

  return comparison;
}

/**
 * Calculate text difference
 * @param {string} text1 - First text
 * @param {string} text2 - Second text
 * @returns {Object} Text diff
 */
function calculateTextDiff(text1, text2) {
  const lines1 = text1.split('\n');
  const lines2 = text2.split('\n');
  
  const added = lines2.filter(line => !lines1.includes(line));
  const removed = lines1.filter(line => !lines2.includes(line));
  
  return {
    added: added,
    removed: removed,
    changed: added.length > 0 || removed.length > 0
  };
}

/**
 * Track screen state over time
 */
export class StateTracker {
  constructor() {
    this.states = [];
    this.maxStates = 10; // Keep last 10 states
  }

  /**
   * Capture and add current state
   * @returns {Promise<ScreenState>} Captured state
   */
  async captureState() {
    const state = await ScreenState.capture();
    this.states.push(state);
    
    // Keep only last N states
    if (this.states.length > this.maxStates) {
      this.states.shift();
    }
    
    return state;
  }

  /**
   * Compare with previous state
   * @returns {Promise<Object|null>} Comparison or null if no previous state
   */
  async compareWithPrevious() {
    if (this.states.length < 2) {
      return null;
    }

    const current = this.states[this.states.length - 1];
    const previous = this.states[this.states.length - 2];
    
    return compareStates(previous, current);
  }

  /**
   * Get state history
   * @returns {Array} State history
   */
  getHistory() {
    return this.states;
  }

  /**
   * Clear state history
   */
  clear() {
    this.states = [];
  }
}

/**
 * Detect state changes that indicate issues
 * @param {Object} comparison - State comparison result
 * @returns {Array} Detected issues from state changes
 */
export function detectStateChangeIssues(comparison) {
  const issues = [];

  // New issues appeared
  if (comparison.summary.hasNewIssues) {
    comparison.issues.newIssues.forEach(issue => {
      issues.push({
        type: 'state_change',
        severity: 'high',
        message: `New issue detected: ${issue.message}`,
        issue: issue,
        detectedAt: comparison.timestamp
      });
    });
  }

  // Text changed unexpectedly (could indicate error)
  if (comparison.changes.textChanged) {
    const errorKeywords = ['error', 'failed', 'exception'];
    const hasErrorKeywords = errorKeywords.some(keyword =>
      comparison.changes.textDiff.added.some(line =>
        line.toLowerCase().includes(keyword)
      )
    );

    if (hasErrorKeywords) {
      issues.push({
        type: 'state_change',
        severity: 'medium',
        message: 'Error text appeared in state change',
        textDiff: comparison.changes.textDiff,
        detectedAt: comparison.timestamp
      });
    }
  }

  return issues;
}
