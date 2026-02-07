/**
 * Optimize PNG/JPEG images in assets/brand (and optionally theme assets) using sharp.
 * Resize to max width if larger, compress for web. Overwrites in place or writes to outDir.
 * Run from repo root: node scripts/shopify/optimize-images.mjs [--theme] [--max-width=2000] [--quality=85]
 */
/* eslint-disable no-console */

import { readdir, stat } from 'fs/promises';
import { dirname, extname, join } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = process.env.ATO_REPO_ROOT || join(__dirname, '..', '..');

const args = process.argv.slice(2);
const optTheme = args.includes('--theme');
const presetArg = args.find((a) => a.startsWith('--preset='));
const preset = presetArg ? presetArg.split('=')[1].toLowerCase() : null;
// Embroidery: high quality, minimal compression, no aggressive resize (suitable for embroidery-ready raster art)
const isEmbroidery = preset === 'embroidery';
const defaultMaxWidth = isEmbroidery ? 4000 : 2000;
const defaultQuality = isEmbroidery ? 98 : 85;
const maxWidth = parseInt(
  args.find((a) => a.startsWith('--max-width='))?.split('=')[1] || String(defaultMaxWidth),
  10,
);
const quality = parseInt(
  args.find((a) => a.startsWith('--quality='))?.split('=')[1] || String(defaultQuality),
  10,
);

let sharp;
try {
  sharp = (await import('sharp')).default;
} catch (_e) {
  console.error('sharp not found. Run: npm install');
  process.exit(1);
}

const brandDir = join(repoRoot, 'assets', 'brand');
const themeAssetsDir = optTheme
  ? join(repoRoot, 'src', 'shopify', 'themes', 'aodrop-theme', 'assets')
  : null;
const exts = new Set(['.png', '.jpg', '.jpeg', '.webp']);

async function optimizeDir(dir) {
  if (!dir) return 0;
  try {
    await stat(dir);
  } catch {
    return 0;
  }
  const entries = await readdir(dir, { withFileTypes: true });
  let count = 0;
  for (const e of entries) {
    if (!e.isFile() || !exts.has(extname(e.name).toLowerCase())) continue;
    const path = join(dir, e.name);
    try {
      const img = sharp(path);
      const meta = await img.metadata();
      const w = meta.width || 0;
      const needResize = w > maxWidth;
      let pipeline = img;
      if (needResize) pipeline = pipeline.resize(maxWidth, null, { withoutEnlargement: true });
      const ext = extname(e.name).toLowerCase();
      if (ext === '.png') pipeline = pipeline.png({ compressionLevel: 9, effort: 10 });
      else if (ext === '.jpg' || ext === '.jpeg') pipeline = pipeline.jpeg({ quality });
      else if (ext === '.webp') pipeline = pipeline.webp({ quality });
      const buf = await pipeline.toBuffer();
      const { writeFile } = await import('fs/promises');
      await writeFile(path, buf);
      count++;
      console.log('Optimized:', e.name);
    } catch (err) {
      console.warn('Skip', e.name, err.message);
    }
  }
  return count;
}

(async () => {
  if (preset) console.log('Preset: %s', preset);
  console.log('Optimizing images (maxWidth=%d, quality=%d)...', maxWidth, quality);
  let n = await optimizeDir(brandDir);
  if (themeAssetsDir) n += await optimizeDir(themeAssetsDir);
  console.log('Done. Optimized %d file(s).', n);
})();
