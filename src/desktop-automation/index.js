/**
 * Desktop Automation - Main Entry Point
 * Exports all desktop automation functionality
 */

// Core automation
export * from './screen-capture.js';
export * from './ocr-reader.js';
export * from './screen-analyzer.js';
export * from './mouse-control.js';
export * from './keyboard-control.js';
export * from './input-simulator.js';
export * from './window-manager.js';

// Issue management
export * from './issue-detector.js';
export * from './pattern-matcher.js';
export * from './state-comparator.js';

// Debugging and fixing
export * from './debugger.js';
export * from './fix-applier.js';
export * from './solution-engine.js';

// Application automation
export * from './apps/cursor-automation.js';
export * from './apps/cursor-navigator.js';
export * from './apps/browser-automation.js';
export * from './apps/system-apps.js';
export * from './apps/file-explorer.js';

// Safety and orchestration
export * from './safety-manager.js';
export * from './confirmation-system.js';
export * from './orchestrator.js';
export * from './task-executor.js';
export * from './workflow-manager.js';

// Utilities
export * from './logger.js';
export * from './error-handler.js';
export * from './config.js';
