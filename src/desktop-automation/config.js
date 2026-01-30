/**
 * Desktop Automation Configuration
 * Centralized configuration for all desktop automation components
 */

/**
 * Default configuration
 */
export const defaultConfig = {
  // Screen capture settings
  screenCapture: {
    defaultFormat: 'png',
    quality: 90,
    multiMonitor: true,
    cacheScreenshots: true,
    screenshotDir: 'docs/screenshots',
  },

  // OCR settings
  ocr: {
    language: 'eng',
    psm: 6, // Page segmentation mode
    confidenceThreshold: 60,
    cacheResults: true,
  },

  // Mouse settings
  mouse: {
    defaultDelay: 50,
    smoothMovement: false,
    movementDuration: 500,
    clickDelay: 100,
  },

  // Keyboard settings
  keyboard: {
    defaultDelay: 50,
    typeDelay: 50,
    keyPressDelay: 100,
  },

  // Window management
  window: {
    activationDelay: 500,
    searchTimeout: 5000,
    windowWaitTimeout: 3000,
  },

  // Issue detection
  issueDetection: {
    checkInterval: 5000,
    severityFilter: null, // null = all severities
    issueTypes: null, // null = all types
    confidenceThreshold: 70,
  },

  // Debugging
  debugging: {
    autoApply: false,
    requireConfirmation: true,
    verifyAfter: true,
    rollbackOnFailure: true,
  },

  // Safety
  safety: {
    requireConfirmation: true,
    emergencyStopEnabled: true,
    logAllActions: true,
    maxRetries: 3,
    retryDelay: 1000,
  },

  // Logging
  logging: {
    level: 'INFO', // DEBUG, INFO, WARN, ERROR, NONE
    logToFile: false,
    logFile: 'logs/automation.log',
    maxLogSize: 10 * 1024 * 1024, // 10MB
  },

  // Performance
  performance: {
    cacheScreenCaptures: true,
    cacheOCRResults: true,
    batchOperations: true,
    maxConcurrentTasks: 3,
    operationTimeout: 30000,
  },
};

/**
 * Current configuration (merged with defaults)
 */
let currentConfig = { ...defaultConfig };

/**
 * Get configuration
 * @param {string} path - Configuration path (e.g., 'screenCapture.quality')
 * @returns {*} Configuration value
 */
export function getConfig(path = null) {
  if (!path) {
    return currentConfig;
  }

  const parts = path.split('.');
  let value = currentConfig;

  for (const part of parts) {
    if (value && typeof value === 'object' && part in value) {
      value = value[part];
    } else {
      return undefined;
    }
  }

  return value;
}

/**
 * Set configuration
 * @param {string} path - Configuration path
 * @param {*} value - Configuration value
 */
export function setConfig(path, value) {
  const parts = path.split('.');
  const lastPart = parts.pop();
  let target = currentConfig;

  for (const part of parts) {
    if (!target[part] || typeof target[part] !== 'object') {
      target[part] = {};
    }
    target = target[part];
  }

  target[lastPart] = value;
}

/**
 * Reset configuration to defaults
 */
export function resetConfig() {
  currentConfig = { ...defaultConfig };
}

/**
 * Load configuration from object
 * @param {Object} config - Configuration object
 */
export function loadConfig(config) {
  currentConfig = {
    ...defaultConfig,
    ...config,
    screenCapture: {
      ...defaultConfig.screenCapture,
      ...(config.screenCapture || {}),
    },
    ocr: {
      ...defaultConfig.ocr,
      ...(config.ocr || {}),
    },
    mouse: {
      ...defaultConfig.mouse,
      ...(config.mouse || {}),
    },
    keyboard: {
      ...defaultConfig.keyboard,
      ...(config.keyboard || {}),
    },
    window: {
      ...defaultConfig.window,
      ...(config.window || {}),
    },
    issueDetection: {
      ...defaultConfig.issueDetection,
      ...(config.issueDetection || {}),
    },
    debugging: {
      ...defaultConfig.debugging,
      ...(config.debugging || {}),
    },
    safety: {
      ...defaultConfig.safety,
      ...(config.safety || {}),
    },
    logging: {
      ...defaultConfig.logging,
      ...(config.logging || {}),
    },
    performance: {
      ...defaultConfig.performance,
      ...(config.performance || {}),
    },
  };
}
