/**
 * Pattern Matcher
 * Matches screen content against known patterns for issue detection
 */

/**
 * Common error patterns
 */
export const ErrorPatterns = {
  // General errors
  generalError: /error|failed|exception|fatal/i,
  notFound: /not found|404|file not found|page not found/i,
  accessDenied: /access denied|permission denied|unauthorized|403/i,
  timeout: /timeout|timed out|request timeout/i,

  // Network errors
  connectionFailed: /connection.*failed|unable.*connect|cannot.*connect/i,
  networkError: /network.*error|network.*unavailable/i,
  dnsError: /dns.*error|dns.*failed/i,

  // Application errors
  applicationError: /application.*error|app.*crash|application.*failed/i,
  extensionError: /extension.*error|extension.*failed/i,
  pluginError: /plugin.*error|plugin.*failed/i,

  // Configuration errors
  configError: /configuration.*error|config.*invalid|settings.*error/i,
  envError: /environment.*variable|env.*not set|missing.*variable/i,

  // Authentication errors
  authError: /authentication.*failed|login.*failed|invalid.*credentials/i,
  tokenError: /token.*expired|token.*invalid|access.*token/i,

  // API errors
  apiError: /api.*error|api.*failed|request.*failed/i,
  rateLimit: /rate.*limit|too.*many.*requests|429/i,

  // Performance issues
  slowLoading: /loading|please wait|processing/i,
  memoryError: /out.*of.*memory|memory.*error/i,

  // UI issues
  elementNotFound: /element.*not found|button.*not found/i,
  renderError: /render.*error|display.*error/i,
};

/**
 * Match text against patterns
 * @param {string} text - Text to match
 * @param {Array|Object} patterns - Pattern(s) to match against
 * @returns {Array} Array of matches
 */
export function matchPatterns(text, patterns) {
  const matches = [];
  const patternList = Array.isArray(patterns) ? patterns : Object.values(patterns);
  const patternNames = Array.isArray(patterns) ? [] : Object.keys(patterns);

  patternList.forEach((pattern, index) => {
    const match = text.match(pattern);
    if (match) {
      matches.push({
        pattern: patternNames[index] || pattern.toString(),
        match: match[0],
        index: match.index,
        fullMatch: match,
      });
    }
  });

  return matches;
}

/**
 * Find specific error type in text
 * @param {string} text - Text to search
 * @param {string} errorType - Type of error to find
 * @returns {Object|null} Match object or null
 */
export function findErrorType(text, errorType) {
  const pattern = ErrorPatterns[errorType];
  if (!pattern) {
    return null;
  }

  const match = text.match(pattern);
  if (match) {
    return {
      type: errorType,
      match: match[0],
      index: match.index,
    };
  }

  return null;
}

/**
 * Extract error details from match
 * @param {Object} match - Pattern match
 * @param {string} text - Full text
 * @returns {Object} Error details
 */
export function extractErrorDetails(match, text) {
  const contextStart = Math.max(0, match.index - 100);
  const contextEnd = Math.min(text.length, match.index + match.match.length + 100);
  const context = text.substring(contextStart, contextEnd);

  return {
    error: match.match,
    context: context,
    position: match.index,
    severity: determineSeverity(match.pattern),
  };
}

/**
 * Determine error severity from pattern
 * @param {string} patternName - Pattern name
 * @returns {string} Severity level
 */
function determineSeverity(patternName) {
  const highSeverity = ['fatal', 'crash', 'accessDenied', 'authError', 'tokenError', 'memoryError'];

  const mediumSeverity = [
    'generalError',
    'connectionFailed',
    'apiError',
    'configError',
    'applicationError',
  ];

  if (highSeverity.some((s) => patternName.includes(s))) {
    return 'high';
  } else if (mediumSeverity.some((s) => patternName.includes(s))) {
    return 'medium';
  } else {
    return 'low';
  }
}

/**
 * Match UI element patterns
 */
export const UIElementPatterns = {
  button: /(button|btn|click|submit|save|cancel|ok|close)/i,
  input: /(input|field|textbox|textarea|enter|type)/i,
  link: /(link|href|url|navigate|go to)/i,
  menu: /(menu|dropdown|select|choose)/i,
  dialog: /(dialog|modal|popup|alert|confirm)/i,
  tab: /(tab|page|section)/i,
};

/**
 * Find UI elements in text
 * @param {string} text - Text to search
 * @returns {Array} Array of UI element matches
 */
export function findUIElements(text) {
  const elements = [];

  Object.keys(UIElementPatterns).forEach((type) => {
    const pattern = UIElementPatterns[type];
    const matches = text.matchAll(new RegExp(pattern, 'gi'));

    for (const match of matches) {
      elements.push({
        type: type,
        text: match[0],
        index: match.index,
      });
    }
  });

  return elements;
}
