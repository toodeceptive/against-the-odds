/**
 * Logger Utility
 * Provides structured logging for desktop automation
 */
/* eslint-disable no-console */

/**
 * Log levels
 */
export const LogLevel = {
  DEBUG: 0,
  INFO: 1,
  WARN: 2,
  ERROR: 3,
  NONE: 4,
};

/**
 * Current log level (default: INFO)
 */
let currentLogLevel = LogLevel.INFO;

/**
 * Set log level
 * @param {number} level - Log level
 */
export function setLogLevel(level) {
  currentLogLevel = level;
}

/**
 * Get log level
 * @returns {number} Current log level
 */
export function getLogLevel() {
  return currentLogLevel;
}

/**
 * Format log message
 * @param {string} level - Log level name
 * @param {string} message - Message
 * @param {Object} data - Additional data
 * @returns {string} Formatted message
 */
function formatMessage(level, message, data = {}) {
  const timestamp = new Date().toISOString();
  const dataStr = Object.keys(data).length > 0 ? ` ${JSON.stringify(data)}` : '';
  return `[${timestamp}] [${level}] ${message}${dataStr}`;
}

/**
 * Debug log
 * @param {string} message - Message
 * @param {Object} data - Additional data
 */
export function debug(message, data = {}) {
  if (currentLogLevel <= LogLevel.DEBUG) {
    console.debug(formatMessage('DEBUG', message, data));
  }
}

/**
 * Info log
 * @param {string} message - Message
 * @param {Object} data - Additional data
 */
export function info(message, data = {}) {
  if (currentLogLevel <= LogLevel.INFO) {
    console.info(formatMessage('INFO', message, data));
  }
}

/**
 * Warn log
 * @param {string} message - Message
 * @param {Object} data - Additional data
 */
export function warn(message, data = {}) {
  if (currentLogLevel <= LogLevel.WARN) {
    console.warn(formatMessage('WARN', message, data));
  }
}

/**
 * Error log
 * @param {string} message - Message
 * @param {Error|Object} error - Error object or data
 */
export function error(message, error = {}) {
  if (currentLogLevel <= LogLevel.ERROR) {
    const errorData =
      error instanceof Error ? { message: error.message, stack: error.stack } : error;
    console.error(formatMessage('ERROR', message, errorData));
  }
}

/**
 * Action log (for automation actions)
 * @param {string} action - Action name
 * @param {Object} details - Action details
 */
export function logAction(action, details = {}) {
  info(`Action: ${action}`, details);
}
