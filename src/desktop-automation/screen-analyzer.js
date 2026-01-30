/**
 * Screen Analyzer
 * Analyzes screen content for elements, state, and issues
 */

import { captureScreen } from './screen-capture.js';
import { extractText, extractStructuredData, findTextOnScreen } from './ocr-reader.js';

/**
 * Analyze current screen state
 * @param {Object} options - Analysis options
 * @returns {Promise<Object>} Screen analysis result
 */
export async function analyzeScreen(options = {}) {
  const {
    captureOptions = {},
    ocrOptions = {},
    detectElements = true,
    detectIssues = true,
  } = options;

  // Capture screen
  const screenshot = await captureScreen(captureOptions);

  // Perform OCR
  const ocrResult = await extractText(screenshot, ocrOptions);

  // Extract structured data
  const structured = detectElements ? await extractStructuredData(screenshot, ocrOptions) : null;

  // Detect issues
  const issues = detectIssues ? await detectScreenIssues(screenshot, ocrResult, structured) : [];

  // Get screen metadata
  const sharp = await import('sharp');
  const metadata = await sharp.default(screenshot).metadata();

  return {
    timestamp: new Date().toISOString(),
    dimensions: {
      width: metadata.width,
      height: metadata.height,
    },
    text: ocrResult.text,
    ocrConfidence: ocrResult.confidence,
    elements: structured,
    issues: issues,
    screenshot: screenshot, // Include for further analysis
  };
}

/**
 * Detect issues on screen
 * @param {Buffer} screenshot - Screenshot buffer
 * @param {Object} ocrResult - OCR result
 * @param {Object} structured - Structured data
 * @returns {Promise<Array>} Array of detected issues
 */
async function detectScreenIssues(screenshot, ocrResult, structured) {
  const issues = [];

  // Check for error messages
  if (structured && structured.errors.length > 0) {
    structured.errors.forEach((error) => {
      issues.push({
        type: 'error_message',
        severity: 'high',
        message: error.text,
        position: error.position,
        detectedAt: new Date().toISOString(),
      });
    });
  }

  // Check for common error patterns in text
  const errorPatterns = [
    /error:\s*(.+)/i,
    /failed:\s*(.+)/i,
    /exception:\s*(.+)/i,
    /invalid\s+(.+)/i,
    /not found/i,
    /access denied/i,
    /permission denied/i,
    /timeout/i,
    /connection (failed|refused|reset)/i,
  ];

  errorPatterns.forEach((pattern) => {
    const matches = ocrResult.text.match(pattern);
    if (matches) {
      issues.push({
        type: 'error_pattern',
        severity: 'high',
        message: matches[0],
        pattern: pattern.toString(),
        detectedAt: new Date().toISOString(),
      });
    }
  });

  // Check for loading indicators (potential performance issues)
  const loadingIndicators = await detectLoadingIndicators(screenshot);
  if (loadingIndicators.length > 0) {
    issues.push({
      type: 'performance',
      severity: 'medium',
      message: 'Loading indicators detected - possible performance issue',
      indicators: loadingIndicators,
      detectedAt: new Date().toISOString(),
    });
  }

  // Check for UI inconsistencies
  const inconsistencies = await detectUIInconsistencies(screenshot, structured);
  if (inconsistencies.length > 0) {
    issues.push({
      type: 'ui_inconsistency',
      severity: 'low',
      message: 'UI inconsistencies detected',
      details: inconsistencies,
      detectedAt: new Date().toISOString(),
    });
  }

  return issues;
}

/**
 * Detect loading indicators on screen
 * @param {Buffer} screenshot - Screenshot buffer
 * @returns {Promise<Array>} Array of loading indicator positions
 */
async function detectLoadingIndicators(screenshot) {
  // This would use image processing to detect spinners, progress bars, etc.
  // For now, check text for loading indicators
  const ocrResult = await extractText(screenshot);
  const loadingText = ['loading', 'please wait', 'processing', '...'];
  const indicators = [];

  loadingText.forEach((text) => {
    const matches = ocrResult.text.toLowerCase().match(new RegExp(text, 'i'));
    if (matches) {
      indicators.push({ type: 'text', text: text });
    }
  });

  return indicators;
}

/**
 * Detect UI inconsistencies
 * @param {Buffer} screenshot - Screenshot buffer
 * @param {Object} structured - Structured data
 * @returns {Promise<Array>} Array of inconsistencies
 */
async function detectUIInconsistencies(screenshot, structured) {
  const inconsistencies = [];

  if (!structured) {
    return inconsistencies;
  }

  // Check for missing expected elements
  // This would be application-specific
  // For now, basic checks

  // Check for overlapping elements (would need image analysis)
  // Check for misaligned elements
  // Check for broken layouts

  return inconsistencies;
}

/**
 * Compare two screen states
 * @param {Object} state1 - First screen state
 * @param {Object} state2 - Second screen state
 * @returns {Object} Comparison result
 */
export function compareScreenStates(state1, state2) {
  const differences = {
    textChanged: state1.text !== state2.text,
    elementsChanged: JSON.stringify(state1.elements) !== JSON.stringify(state2.elements),
    issuesChanged: state1.issues.length !== state2.issues.length,
    newIssues: state2.issues.filter(
      (issue) => !state1.issues.some((i) => i.message === issue.message)
    ),
    resolvedIssues: state1.issues.filter(
      (issue) => !state2.issues.some((i) => i.message === issue.message)
    ),
  };

  return {
    changed: differences.textChanged || differences.elementsChanged || differences.issuesChanged,
    differences: differences,
    timestamp: new Date().toISOString(),
  };
}

/**
 * Find element on screen by text
 * @param {string} searchText - Text to find
 * @param {Object} options - Search options
 * @returns {Promise<Object|null>} Element information or null
 */
export async function findElementByText(searchText, options = {}) {
  const screenshot = await captureScreen();
  const matches = await findTextOnScreen(screenshot, searchText, options);

  if (matches.length > 0) {
    // Return first match
    return {
      text: matches[0].text,
      position: matches[0].position,
      bbox: matches[0].bbox,
      confidence: matches[0].confidence,
    };
  }

  return null;
}

/**
 * Get screen state summary
 * @param {Object} options - Analysis options
 * @returns {Promise<Object>} Screen state summary
 */
export async function getScreenStateSummary(options = {}) {
  const analysis = await analyzeScreen(options);

  return {
    timestamp: analysis.timestamp,
    hasText: analysis.text.length > 0,
    textLength: analysis.text.length,
    elementCount: analysis.elements
      ? analysis.elements.buttons.length +
        analysis.elements.inputs.length +
        analysis.elements.labels.length
      : 0,
    issueCount: analysis.issues.length,
    criticalIssues: analysis.issues.filter((i) => i.severity === 'high').length,
    ocrConfidence: analysis.ocrConfidence,
  };
}
