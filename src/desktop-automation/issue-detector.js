/**
 * Issue Detection Engine
 * Automatically detects issues across applications and system
 */

import { analyzeScreen } from './screen-analyzer.js';

/**
 * Detect all issues on current screen
 * @param {Object} options - Detection options
 * @returns {Promise<Array>} Array of detected issues
 */
export async function detectIssues(options = {}) {
  const {
    application = null, // Application context
    severityFilter = null, // Filter by severity
    issueTypes = null // Filter by issue types
  } = options;

  // Analyze current screen
  const analysis = await analyzeScreen({
    detectElements: true,
    detectIssues: true
  });

  let issues = analysis.issues || [];

  // Additional issue detection
  const additionalIssues = await detectAdditionalIssues(analysis, application);
  issues = [...issues, ...additionalIssues];

  // Filter by severity if specified
  if (severityFilter) {
    issues = issues.filter(issue => issue.severity === severityFilter);
  }

  // Filter by issue types if specified
  if (issueTypes && Array.isArray(issueTypes)) {
    issues = issues.filter(issue => issueTypes.includes(issue.type));
  }

  return issues;
}

/**
 * Detect additional issues beyond basic screen analysis
 * @param {Object} analysis - Screen analysis result
 * @param {string} application - Application context
 * @returns {Promise<Array>} Additional issues
 */
async function detectAdditionalIssues(analysis, application) {
  const issues = [];

  // Check for common application-specific issues
  if (application) {
    const appIssues = await detectApplicationIssues(analysis, application);
    issues.push(...appIssues);
  }

  // Check for performance issues
  const perfIssues = await detectPerformanceIssues(analysis);
  issues.push(...perfIssues);

  // Check for configuration issues
  const configIssues = await detectConfigurationIssues(analysis);
  issues.push(...configIssues);

  // Check for connectivity issues
  const connectivityIssues = await detectConnectivityIssues(analysis);
  issues.push(...connectivityIssues);

  return issues;
}

/**
 * Detect application-specific issues
 * @param {Object} analysis - Screen analysis
 * @param {string} application - Application name
 * @returns {Promise<Array>} Application issues
 */
async function detectApplicationIssues(analysis, application) {
  const issues = [];

  // Application-specific patterns
  const appPatterns = {
    'cursor': [
      { pattern: /extension.*failed/i, type: 'extension_error', severity: 'medium' },
      { pattern: /language server.*error/i, type: 'language_server_error', severity: 'high' }
    ],
    'chrome': [
      { pattern: /this page.*not available/i, type: 'page_not_found', severity: 'medium' },
      { pattern: /connection.*refused/i, type: 'connection_error', severity: 'high' }
    ],
    'shopify': [
      { pattern: /api.*error/i, type: 'api_error', severity: 'high' },
      { pattern: /authentication.*failed/i, type: 'auth_error', severity: 'high' }
    ]
  };

  const patterns = appPatterns[application.toLowerCase()] || [];
  
  patterns.forEach(({ pattern, type, severity }) => {
    if (pattern.test(analysis.text)) {
      issues.push({
        type: type,
        severity: severity,
        message: `Application-specific issue detected: ${type}`,
        application: application,
        detectedAt: new Date().toISOString()
      });
    }
  });

  return issues;
}

/**
 * Detect performance issues
 * @param {Object} analysis - Screen analysis
 * @returns {Promise<Array>} Performance issues
 */
async function detectPerformanceIssues(analysis) {
  const issues = [];

  // Check for loading indicators
  const loadingPatterns = [
    /loading\.\.\./i,
    /please wait/i,
    /processing/i,
    /spinner/i
  ];

  const hasLoading = loadingPatterns.some(pattern => pattern.test(analysis.text));
  
  if (hasLoading) {
    // Check if loading has been present for too long (would need state tracking)
    issues.push({
      type: 'performance',
      severity: 'medium',
      message: 'Loading indicators detected - possible performance issue',
      detectedAt: new Date().toISOString()
    });
  }

  return issues;
}

/**
 * Detect configuration issues
 * @param {Object} analysis - Screen analysis
 * @returns {Promise<Array>} Configuration issues
 */
async function detectConfigurationIssues(analysis) {
  const issues = [];

  // Check for configuration-related errors
  const configPatterns = [
    /configuration.*missing/i,
    /settings.*invalid/i,
    /config.*error/i,
    /environment.*variable/i
  ];

  configPatterns.forEach(pattern => {
    if (pattern.test(analysis.text)) {
      issues.push({
        type: 'configuration',
        severity: 'high',
        message: 'Configuration issue detected',
        pattern: pattern.toString(),
        detectedAt: new Date().toISOString()
      });
    }
  });

  return issues;
}

/**
 * Detect connectivity issues
 * @param {Object} analysis - Screen analysis
 * @returns {Promise<Array>} Connectivity issues
 */
async function detectConnectivityIssues(analysis) {
  const issues = [];

  const connectivityPatterns = [
    /connection.*failed/i,
    /network.*error/i,
    /timeout/i,
    /unable.*connect/i,
    /dns.*error/i,
    /no internet/i
  ];

  connectivityPatterns.forEach(pattern => {
    if (pattern.test(analysis.text)) {
      issues.push({
        type: 'connectivity',
        severity: 'high',
        message: 'Connectivity issue detected',
        pattern: pattern.toString(),
        detectedAt: new Date().toISOString()
      });
    }
  });

  return issues;
}

/**
 * Monitor screen for issues continuously
 * @param {Object} options - Monitoring options
 * @returns {Promise<Function>} Stop function
 */
export async function monitorIssues(options = {}) {
  const {
    interval = 5000,
    callback = null,
    onIssue = null
  } = options;

  let monitoring = true;
  let lastIssues = [];

  const monitor = async () => {
    while (monitoring) {
      try {
        const issues = await detectIssues(options);
        
        // Check for new issues
        const newIssues = issues.filter(issue =>
          !lastIssues.some(last => last.message === issue.message)
        );

        if (newIssues.length > 0 && onIssue) {
          newIssues.forEach(issue => onIssue(issue));
        }

        if (callback) {
          callback(issues);
        }

        lastIssues = issues;
      } catch (err) {
        // Error handling - monitoring continues
        // Could log to error handler if needed
      }

      await new Promise(resolve => setTimeout(resolve, interval));
    }
  };

  monitor();

  return () => {
    monitoring = false;
  };
}

/**
 * Classify issue by type and severity
 * @param {Object} issue - Issue object
 * @returns {Object} Classified issue
 */
export function classifyIssue(issue) {
  const classification = {
    category: 'unknown',
    priority: 'medium',
    actionable: false,
    fixable: false
  };

  // Categorize by type
  const categories = {
    'error_message': 'error',
    'error_pattern': 'error',
    'performance': 'performance',
    'ui_inconsistency': 'ui',
    'configuration': 'configuration',
    'connectivity': 'network',
    'api_error': 'api',
    'auth_error': 'authentication'
  };

  classification.category = categories[issue.type] || 'unknown';

  // Determine priority based on severity
  const priorityMap = {
    'high': 'urgent',
    'medium': 'high',
    'low': 'medium'
  };

  classification.priority = priorityMap[issue.severity] || 'medium';

  // Determine if actionable
  classification.actionable = [
    'error_message',
    'error_pattern',
    'configuration',
    'connectivity',
    'api_error',
    'auth_error'
  ].includes(issue.type);

  // Determine if automatically fixable
  classification.fixable = [
    'configuration',
    'connectivity',
    'auth_error'
  ].includes(issue.type);

  return {
    ...issue,
    classification: classification
  };
}
