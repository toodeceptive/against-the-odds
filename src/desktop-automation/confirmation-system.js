/**
 * Confirmation System
 * Handles user confirmation for sensitive operations
 */

import { requiresConfirmation, isDestructive } from './safety-manager.js';
import { saveScreenshot } from './screen-capture.js';
import { warn } from './logger.js';

/**
 * Confirmation request
 */
export class ConfirmationRequest {
  constructor(action, details) {
    this.action = action;
    this.details = details;
    this.timestamp = new Date().toISOString();
    this.confirmed = false;
    this.rejected = false;
  }
}

/**
 * Pending confirmations
 */
const pendingConfirmations = [];

/**
 * Request confirmation for action
 * @param {string} action - Action description
 * @param {Object} details - Action details
 * @param {Object} options - Confirmation options
 * @returns {Promise<boolean>} True if confirmed
 */
export async function requestConfirmation(action, details = {}) {
  // Options available for future implementation
  // const { timeout = 30000, autoReject = true } = options;

  // Check if confirmation is actually required
  if (!requiresConfirmation(action)) {
    return true; // No confirmation needed
  }

  // Create confirmation request
  const request = new ConfirmationRequest(action, details);
  pendingConfirmations.push(request);

  // Capture screen for context
  const screenshot = await saveScreenshot(`confirmation-${Date.now()}.png`);

  // Present confirmation (would integrate with UI or logging)
  warn('=== CONFIRMATION REQUIRED ===');
  warn(`Action: ${action}`);
  warn(`Details: ${JSON.stringify(details)}`);
  warn(`Screenshot: ${screenshot}`);
  warn('Type "confirm" to proceed or "reject" to cancel');
  warn('============================');

  // Wait for confirmation (in real implementation, this would wait for user input)
  // For now, return false to require manual confirmation
  // In actual implementation, this would integrate with a UI or input system
  
  return false; // Default to requiring manual confirmation
}

/**
 * Confirm action
 * @param {string} actionId - Action identifier
 * @returns {boolean} True if confirmed
 */
export function confirmAction(actionId) {
  const request = pendingConfirmations.find(r => r.action === actionId);
  if (request) {
    request.confirmed = true;
    return true;
  }
  return false;
}

/**
 * Reject action
 * @param {string} actionId - Action identifier
 * @returns {boolean} True if rejected
 */
export function rejectAction(actionId) {
  const request = pendingConfirmations.find(r => r.action === actionId);
  if (request) {
    request.rejected = true;
    return true;
  }
  return false;
}

/**
 * Get pending confirmations
 * @returns {Array} Array of pending confirmation requests
 */
export function getPendingConfirmations() {
  return pendingConfirmations.filter(r => !r.confirmed && !r.rejected);
}

/**
 * Clear confirmed/rejected requests
 */
export function clearProcessedConfirmations() {
  const processed = pendingConfirmations.filter(r => r.confirmed || r.rejected);
  processed.forEach(r => {
    const index = pendingConfirmations.indexOf(r);
    if (index > -1) {
      pendingConfirmations.splice(index, 1);
    }
  });
}

/**
 * Format confirmation message
 * @param {string} action - Action description
 * @param {Object} details - Action details
 * @returns {string} Formatted message
 */
export function formatConfirmationMessage(action, details) {
  let message = `CONFIRMATION REQUIRED\n\n`;
  message += `Action: ${action}\n`;
  
  if (details.description) {
    message += `Description: ${details.description}\n`;
  }
  
  if (isDestructive(action)) {
    message += `\n⚠️ WARNING: This is a destructive operation!\n`;
  }
  
  if (details.risks && details.risks.length > 0) {
    message += `\nRisks:\n`;
    details.risks.forEach(risk => {
      message += `  - ${risk}\n`;
    });
  }
  
  if (details.rollback) {
    message += `\nRollback available: Yes\n`;
  }
  
  message += `\nProceed? (yes/no)`;
  
  return message;
}
