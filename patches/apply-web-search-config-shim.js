// SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
// SPDX-License-Identifier: Apache-2.0
// Narrow OpenClaw runtime shim for Brave web-search auth only.
const fs = require('fs');
const path = require('path');
const root = process.argv[2];
if (!root) {
  console.error('usage: node apply-web-search-config-shim.js <openclaw-root>');
  process.exit(1);
}
const distDir = path.join(root, 'dist');
function listJsFiles(dir) {
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...listJsFiles(full));
    } else if (entry.isFile() && entry.name.endsWith('.js')) {
      files.push(full);
    }
  }
  return files;
}
const targets = listJsFiles(distDir);
const oldText = 'process.env.BRAVE_API_KEY';
const newText = 'process.env.BRAVE_API_KEY || process.env.OPENCLAW_BRAVE_API_KEY';
let patched = 0;
for (const filePath of targets) {
  const text = fs.readFileSync(filePath, 'utf8');
  if (!text.includes(oldText) || text.includes(newText)) continue;
  fs.writeFileSync(filePath, text.replaceAll(oldText, newText));
  patched += 1;
}
if (patched === 0) {
  console.error('no process.env.BRAVE_API_KEY targets patched');
  process.exit(2);
}
console.log(`patched ${patched} dist files`);
