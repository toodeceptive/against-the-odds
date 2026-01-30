/**
 * Error Handler
 * Centralized error handling and recovery utilities
 */

import { error, warn, debug } from './logger.js';

/**
 * Error types
 */
export const ErrorType = {
  NETWORK: 'network',
  PERMISSION: 'permission',
  NOT_FOUND: 'not_found',
  TIMEOUT: 'timeout',
  VALIDATION: 'validation',
  UNKNOWN: 'unknown',
};

/**
 * Classify error type
 * @param {Error} err - Error object
 * @returns {string} Error type
 */
export function classifyError(err) {
  const message = err.message?.toLowerCase() || '';
  const code = err.code?.toLowerCase() || '';

  if (message.includes('network') || message.includes('connection') || code === 'enetwork') {
    return ErrorType.NETWORK;
  }
  if (message.includes('permission') || message.includes('access denied') || code === 'eacces') {
    return ErrorType.PERMISSION;
  }
  if (message.includes('not found') || message.includes('enoent')) {
    return ErrorType.NOT_FOUND;
  }
  if (message.includes('timeout') || code === 'etimeout') {
    return ErrorType.TIMEOUT;
  }
  if (message.includes('invalid') || message.includes('validation')) {
    return ErrorType.VALIDATION;
  }

  return ErrorType.UNKNOWN;
}

/**
 * Handle error with recovery
 * @param {Error} err - Error object
 * @param {Object} context - Error context
 * @param {Object} options - Handling options
 * @returns {Promise<Object>} Recovery result
 */
export async function handleError(err, context = {}, options = {}) {
  const { retry = false, maxRetries = 3, retryDelay = 1000, fallback = null, log = true } = options;

  const errorType = classifyError(err);
  const errorInfo = {
    type: errorType,
    message: err.message,
    stack: err.stack,
    context: context,
    timestamp: new Date().toISOString(),
  };

  if (log) {
    error(`Error in ${context.operation || 'unknown operation'}`, errorInfo);
  }

  // Attempt recovery
  if (retry && maxRetries > 0) {
    debug(`Retrying operation (${maxRetries} attempts remaining)`);
    await new Promise((resolve) => setTimeout(resolve, retryDelay));
    return { recovered: true, retry: true, attemptsRemaining: maxRetries - 1 };
  }

  // Use fallback if available
  if (fallback && typeof fallback === 'function') {
    try {
      const result = await fallback();
      warn('Fallback function executed successfully');
      return { recovered: true, fallback: true, result: result };
    } catch (fallbackError) {
      error('Fallback function also failed', fallbackError);
    }
  }

  return {
    recovered: false,
    error: errorInfo,
  };
}

/**
 * Wrap async function with error handling
 * @param {Function} fn - Function to wrap
 * @param {Object} options - Error handling options
 * @returns {Function} Wrapped function
 */
export function withErrorHandling(fn, options = {}) {
  return async (...args) => {
    try {
      return await fn(...args);
    } catch (err) {
      const context = {
        operation: fn.name || 'anonymous',
        args: args,
      };
      const result = await handleError(err, context, options);

      if (!result.recovered) {
        throw err;
      }

      return result.result;
    }
  };
}

/**
 * Create safe async function
 * @param {Function} fn - Function to make safe
 * @param {*} defaultValue - Default return value on error
 * @returns {Function} Safe function
 */
export function safeAsync(fn, defaultValue = null) {
  return async (...args) => {
    try {
      return await fn(...args);
    } catch (err) {
      error(`Safe function error in ${fn.name || 'anonymous'}`, err);
      return defaultValue;
    }
  };
}
