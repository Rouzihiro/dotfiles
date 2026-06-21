#!/usr/bin/env node
// Strips // and /* */ comments plus trailing commas, then validates as JSON.
// This matches what JSONC consumers (VS Code, swaync, Waybar, etc.) actually accept.
'use strict';
const fs = require('fs');

function stripJsonComments(text) {
  let result = '';
  let inString = false;
  let stringChar = '';
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    const next = text[i + 1];
    if (inString) {
      result += c;
      if (c === '\\') { result += text[++i] ?? ''; continue; }
      if (c === stringChar) inString = false;
      continue;
    }
    if (c === '"' || c === "'") { inString = true; stringChar = c; result += c; continue; }
    if (c === '/' && next === '/') {
      while (i < text.length && text[i] !== '\n') i++;
      result += '\n';
      continue;
    }
    if (c === '/' && next === '*') {
      i += 2;
      while (i < text.length && !(text[i] === '*' && text[i + 1] === '/')) i++;
      i++;
      continue;
    }
    result += c;
  }
  return result;
}

function stripTrailingCommas(text) {
  return text.replace(/,(\s*[}\]])/g, '$1');
}

let failed = false;
for (const file of process.argv.slice(2)) {
  try {
    const raw = fs.readFileSync(file, 'utf8');
    const stripped = stripTrailingCommas(stripJsonComments(raw));
    JSON.parse(stripped);
  } catch (err) {
    console.error(`${file}: ${err.message}`);
    failed = true;
  }
}
process.exit(failed ? 1 : 0);
