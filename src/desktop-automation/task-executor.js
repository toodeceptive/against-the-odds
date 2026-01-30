/**
 * Task Executor
 * Executes automation tasks with error handling and retry logic
 */

/**
 * Task execution result
 */
export class TaskResult {
  constructor(task) {
    this.task = task;
    this.timestamp = new Date().toISOString();
    this.success = false;
    this.error = null;
    this.duration = 0;
    this.retries = 0;
  }
}

/**
 * Execute task with retry logic
 * @param {Function} taskFunction - Function to execute
 * @param {Object} options - Execution options
 * @returns {Promise<TaskResult>} Task result
 */
export async function executeTask(taskFunction, options = {}) {
  const { maxRetries = 3, retryDelay = 1000, timeout = 30000 } = options;

  const result = new TaskResult(taskFunction.name || 'anonymous');
  const startTime = Date.now();

  try {
    // Execute with timeout
    const taskPromise = taskFunction();
    const timeoutPromise = new Promise((_, reject) =>
      setTimeout(() => reject(new Error('Task timeout')), timeout)
    );

    await Promise.race([taskPromise, timeoutPromise]);

    result.success = true;
    result.duration = Date.now() - startTime;
  } catch (error) {
    result.error = error.message;
    result.duration = Date.now() - startTime;

    // Retry if retries remaining
    if (result.retries < maxRetries) {
      result.retries++;
      await new Promise((resolve) => setTimeout(resolve, retryDelay * result.retries));
      return await executeTask(taskFunction, { ...options, maxRetries: maxRetries - 1 });
    }
  }

  return result;
}

/**
 * Execute multiple tasks in sequence
 * @param {Array<Function>} tasks - Array of task functions
 * @param {Object} options - Execution options
 * @returns {Promise<Array<TaskResult>>} Array of task results
 */
export async function executeTasksSequential(tasks, options = {}) {
  const results = [];

  for (const task of tasks) {
    const result = await executeTask(task, options);
    results.push(result);

    // Stop on critical failure if configured
    if (options.stopOnFailure && !result.success) {
      break;
    }
  }

  return results;
}

/**
 * Execute multiple tasks in parallel
 * @param {Array<Function>} tasks - Array of task functions
 * @param {Object} options - Execution options
 * @returns {Promise<Array<TaskResult>>} Array of task results
 */
export async function executeTasksParallel(tasks, options = {}) {
  const { maxConcurrent = 3 } = options;

  const results = [];
  const executing = [];

  for (const task of tasks) {
    // Wait if at max concurrent
    if (executing.length >= maxConcurrent) {
      await Promise.race(executing);
    }

    // Execute task
    const taskPromise = executeTask(task, options).then((result) => {
      executing.splice(executing.indexOf(taskPromise), 1);
      return result;
    });

    executing.push(taskPromise);
    results.push(taskPromise);
  }

  return await Promise.all(results);
}
