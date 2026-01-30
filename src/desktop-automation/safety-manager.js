/**
 * Safety Manager
 * Manages safety controls and restrictions for desktop automation
 */

/**
 * Safety rules configuration
 */
export const SafetyRules = {
  // Actions that always require confirmation
  requireConfirmation: [
    'delete',
    'remove',
    'uninstall',
    'format',
    'reset',
    'clear',
    'wipe',
    'destroy',
  ],

  // Actions that are considered destructive
  destructive: [
    'delete',
    'remove',
    'uninstall',
    'format',
    'reset',
    'clear',
    'wipe',
    'destroy',
    'close', // Closing applications
    'restart', // Restarting applications
    'shutdown', // System shutdown
    'logout', // User logout
  ],

  // Actions that affect credentials
  credentialRelated: [
    'token',
    'password',
    'credential',
    'authentication',
    'login',
    'api_key',
    'secret',
  ],

  // Actions that affect system settings
  systemSettings: ['registry', 'service', 'process', 'system', 'environment', 'path', 'variable'],
};

/**
 * Check if action requires confirmation
 * @param {string} action - Action description
 * @returns {boolean} True if confirmation required
 */
export function requiresConfirmation(action) {
  const actionLower = action.toLowerCase();

  // Check against safety rules
  return (
    SafetyRules.requireConfirmation.some((keyword) => actionLower.includes(keyword)) ||
    SafetyRules.destructive.some((keyword) => actionLower.includes(keyword)) ||
    SafetyRules.credentialRelated.some((keyword) => actionLower.includes(keyword)) ||
    SafetyRules.systemSettings.some((keyword) => actionLower.includes(keyword))
  );
}

/**
 * Check if action is destructive
 * @param {string} action - Action description
 * @returns {boolean} True if destructive
 */
export function isDestructive(action) {
  const actionLower = action.toLowerCase();
  return SafetyRules.destructive.some((keyword) => actionLower.includes(keyword));
}

/**
 * Check if action affects credentials
 * @param {string} action - Action description
 * @returns {boolean} True if credential-related
 */
export function isCredentialRelated(action) {
  const actionLower = action.toLowerCase();
  return SafetyRules.credentialRelated.some((keyword) => actionLower.includes(keyword));
}

/**
 * Validate action before execution
 * @param {string} action - Action to validate
 * @param {Object} context - Action context
 * @returns {Object} Validation result
 */
export function validateAction(action, context = {}) {
  const validation = {
    allowed: true,
    requiresConfirmation: false,
    riskLevel: 'low',
    warnings: [],
    errors: [],
  };

  // Check if confirmation required
  validation.requiresConfirmation = requiresConfirmation(action);

  // Determine risk level
  if (isDestructive(action)) {
    validation.riskLevel = 'high';
    validation.warnings.push('This is a destructive operation');
  } else if (isCredentialRelated(action)) {
    validation.riskLevel = 'high';
    validation.warnings.push('This operation affects credentials');
  } else if (requiresConfirmation(action)) {
    validation.riskLevel = 'medium';
    validation.warnings.push('This operation requires confirmation');
  }

  // Check context for additional risks
  if (context.application === 'system' && validation.riskLevel === 'low') {
    validation.riskLevel = 'medium';
    validation.warnings.push('System-level operation');
  }

  // Block extremely dangerous operations
  const blockedActions = ['format c:', 'delete system32', 'rm -rf /'];
  if (blockedActions.some((blocked) => action.toLowerCase().includes(blocked))) {
    validation.allowed = false;
    validation.errors.push('This operation is blocked for safety');
  }

  return validation;
}

/**
 * Safety check before executing fix
 * @param {Object} fixStrategy - Fix strategy
 * @returns {Object} Safety check result
 */
export function checkFixSafety(fixStrategy) {
  const safety = {
    safe: true,
    requiresConfirmation: false,
    risks: [],
    recommendations: [],
  };

  // Check each step
  fixStrategy.steps.forEach((step) => {
    const validation = validateAction(step);

    if (!validation.allowed) {
      safety.safe = false;
      safety.risks.push(`Step blocked: ${step}`);
    }

    if (validation.requiresConfirmation) {
      safety.requiresConfirmation = true;
      safety.risks.push(`Step requires confirmation: ${step}`);
    }

    if (validation.riskLevel === 'high') {
      safety.risks.push(`High-risk step: ${step}`);
      safety.recommendations.push(`Review step carefully: ${step}`);
    }
  });

  return safety;
}

/**
 * Emergency stop flag
 */
let emergencyStop = false;

/**
 * Set emergency stop
 * @param {boolean} stop - Stop flag
 */
export function setEmergencyStop(stop) {
  emergencyStop = stop;
}

/**
 * Check if emergency stop is active
 * @returns {boolean} True if stopped
 */
export function isEmergencyStop() {
  return emergencyStop;
}

/**
 * Check if action can proceed (considering emergency stop)
 * @returns {boolean} True if can proceed
 */
export function canProceed() {
  return !emergencyStop;
}
