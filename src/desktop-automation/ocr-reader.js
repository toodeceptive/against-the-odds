/**
 * OCR Reader Library
 * Provides OCR capabilities for reading text from screen captures
 */

import { createWorker } from 'tesseract.js';

let worker = null;

/**
 * Initialize OCR worker
 * @returns {Promise<Worker>} Tesseract worker
 */
async function getWorker() {
  if (!worker) {
    worker = await createWorker('eng', 1, {
      logger: (m) => {
        // Suppress verbose logging in production
        if (m.status === 'recognizing text') {
          // Only log progress occasionally
        }
      },
    });
  }
  return worker;
}

/**
 * Extract text from image using OCR
 * @param {Buffer} imageBuffer - Image buffer
 * @param {Object} options - OCR options
 * @returns {Promise<Object>} OCR result with text and confidence
 */
export async function extractText(imageBuffer, options = {}) {
  const {
    language = 'eng',
    psm = 6, // Page segmentation mode (6 = uniform block of text)
    confidenceThreshold = 60,
  } = options;

  const ocrWorker = await getWorker();

  // Set language if different
  if (language !== 'eng') {
    await ocrWorker.loadLanguage(language);
    await ocrWorker.initialize(language);
  }

  // Set page segmentation mode
  await ocrWorker.setParameters({
    tessedit_pageseg_mode: psm,
  });

  // Perform OCR
  const { data } = await ocrWorker.recognize(imageBuffer);

  // Filter by confidence if threshold set
  const words = data.words.filter((word) => word.confidence >= confidenceThreshold);
  const lines = data.lines.filter((line) =>
    line.words.some((word) => word.confidence >= confidenceThreshold)
  );

  return {
    text: data.text,
    confidence: data.confidence,
    words: words,
    lines: lines,
    paragraphs: data.paragraphs,
    blocks: data.blocks,
  };
}

/**
 * Extract text from specific region
 * @param {Buffer} imageBuffer - Full image buffer
 * @param {Object} region - Region {x, y, width, height}
 * @param {Object} options - OCR options
 * @returns {Promise<Object>} OCR result
 */
export async function extractTextFromRegion(imageBuffer, region, options = {}) {
  const sharp = await import('sharp');
  const { x, y, width, height } = region;

  // Crop image to region
  const cropped = await sharp
    .default(imageBuffer)
    .extract({ left: x, top: y, width, height })
    .toBuffer();

  return await extractText(cropped, options);
}

/**
 * Find text on screen
 * @param {Buffer} imageBuffer - Image buffer
 * @param {string} searchText - Text to find
 * @param {Object} options - Search options
 * @returns {Promise<Array>} Array of matches with positions
 */
export async function findTextOnScreen(imageBuffer, searchText, options = {}) {
  const { caseSensitive = false, partialMatch = true } = options;

  const ocrResult = await extractText(imageBuffer, options);
  const matches = [];

  ocrResult.words.forEach((word) => {
    const wordText = caseSensitive ? word.text : word.text.toLowerCase();
    const search = caseSensitive ? searchText : searchText.toLowerCase();

    if (partialMatch ? wordText.includes(search) : wordText === search) {
      matches.push({
        text: word.text,
        confidence: word.confidence,
        bbox: word.bbox, // Bounding box {x0, y0, x1, y1}
        position: {
          x: word.bbox.x0 + (word.bbox.x1 - word.bbox.x0) / 2,
          y: word.bbox.y0 + (word.bbox.y1 - word.bbox.y0) / 2,
        },
      });
    }
  });

  return matches;
}

/**
 * Extract structured data from screen (forms, tables, etc.)
 * @param {Buffer} imageBuffer - Image buffer
 * @param {Object} options - Extraction options
 * @returns {Promise<Object>} Structured data
 */
export async function extractStructuredData(imageBuffer, options = {}) {
  const ocrResult = await extractText(imageBuffer, options);

  // Try to identify common UI elements
  const structured = {
    text: ocrResult.text,
    buttons: [],
    inputs: [],
    labels: [],
    errors: [],
    headings: [],
  };

  // Look for button-like text (all caps, short, common button words)
  ocrResult.words.forEach((word) => {
    const text = word.text.trim();

    // Detect buttons
    if (/^(OK|Cancel|Submit|Save|Delete|Edit|Add|Remove|Close|Yes|No|Apply|Reset)$/i.test(text)) {
      structured.buttons.push({
        text: text,
        position: {
          x: word.bbox.x0 + (word.bbox.x1 - word.bbox.x0) / 2,
          y: word.bbox.y0 + (word.bbox.y1 - word.bbox.y0) / 2,
        },
        bbox: word.bbox,
      });
    }

    // Detect error messages
    if (/error|failed|invalid|warning|exception|fatal/i.test(text)) {
      structured.errors.push({
        text: text,
        position: {
          x: word.bbox.x0 + (word.bbox.x1 - word.bbox.x0) / 2,
          y: word.bbox.y0 + (word.bbox.y1 - word.bbox.y0) / 2,
        },
        bbox: word.bbox,
      });
    }

    // Detect headings (larger text, often at top)
    if (word.bbox.y1 - word.bbox.y0 > 20) {
      // Larger font
      structured.headings.push({
        text: text,
        position: {
          x: word.bbox.x0 + (word.bbox.x1 - word.bbox.x0) / 2,
          y: word.bbox.y0 + (word.bbox.y1 - word.bbox.y0) / 2,
        },
        bbox: word.bbox,
      });
    }
  });

  return structured;
}

/**
 * Clean up OCR worker
 */
export async function cleanup() {
  if (worker) {
    await worker.terminate();
    worker = null;
  }
}
