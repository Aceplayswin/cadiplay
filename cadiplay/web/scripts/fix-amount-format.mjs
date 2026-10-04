import fs from 'fs';
import path from 'path';

function walk(dir, acc = []) {
  for (const name of fs.readdirSync(dir)) {
    if (name === 'node_modules' || name === '.next') continue;
    const p = path.join(dir, name);
    if (fs.statSync(p).isDirectory()) walk(p, acc);
    else if (/\.(js|jsx)$/.test(name)) acc.push(p);
  }
  return acc;
}

const root = path.resolve('src');
const skip = new Set([
  path.normalize(path.join(root, 'lib/datetime.js')),
  path.normalize(path.join(root, 'lib/money.js')),
]);

const USDT_ONE_LINE =
  /const usdt = \((?:n|v)\) => `USDT \$\{Number\((?:n|v)(?: \?\? 0)?\)\.toLocaleString\('en-IN'\)\}`;\r?\n/;
const USDT_MULTI =
  /const usdt = \(n\) =>\r?\n  `USDT \$\{Number\(n \?\? 0\)\.toLocaleString\('en-IN', \{ minimumFractionDigits: 2, maximumFractionDigits: 2 \}\)\}`;\r?\n/;

function addImport(src, specifier) {
  if (src.includes("from '@/lib/money'")) {
    return src.replace(/import \{([^}]+)\} from '@\/lib\/money';/, (m, inner) => {
      const parts = inner.split(',').map((x) => x.trim()).filter(Boolean);
      if (!parts.includes(specifier)) parts.push(specifier);
      return `import { ${parts.join(', ')} } from '@/lib/money';`;
    });
  }
  const importRe = /^(import[^\n]*\n)+/m;
  const m = src.match(importRe);
  const line = `import { ${specifier} } from '@/lib/money';\n`;
  return m ? src.replace(importRe, `${m[0]}${line}`) : line + src;
}

let helperCount = 0;
for (const file of walk(root)) {
  if (skip.has(path.normalize(file))) continue;
  let s = fs.readFileSync(file, 'utf8');
  const orig = s;
  if (USDT_ONE_LINE.test(s)) {
    s = s.replace(USDT_ONE_LINE, '');
    s = addImport(s, 'formatAmount as usdt');
  }
  if (USDT_MULTI.test(s)) {
    s = s.replace(USDT_MULTI, '');
    s = addImport(s, 'formatAmount');
    s = s.replace(
      "import { formatAmount } from '@/lib/money';\n",
      "import { formatAmount } from '@/lib/money';\nconst usdt = (n) => formatAmount(n, { minimumFractionDigits: 2 });\n",
    );
  }
  if (s !== orig) {
    fs.writeFileSync(file, s);
    helperCount += 1;
    console.log('helper', path.relative(root, file));
  }
}

let inlineCount = 0;
for (const file of walk(root)) {
  if (skip.has(path.normalize(file))) continue;
  let s = fs.readFileSync(file, 'utf8');
  const orig = s;
  if (!s.includes("toLocaleString('en-IN')") && !s.includes("toLocaleString('en-IN',")) continue;

  let usedNumber = false;

  s = s.replace(
    /Number\(([^)]+)\)\.toLocaleString\('en-IN', \{ minimumFractionDigits: 2, maximumFractionDigits: 2 \}\)/g,
    (_, expr) => {
      usedNumber = true;
      return `formatAmountNumber(${expr.trim()}, { minimumFractionDigits: 2 })`;
    },
  );
  s = s.replace(/Number\(([^)]+)\)\.toLocaleString\('en-IN'\)/g, (_, expr) => {
    usedNumber = true;
    return `formatAmountNumber(${expr.trim()})`;
  });
  s = s.replace(/parseFloat\(([^)]+)\)\.toLocaleString\('en-IN'\)/g, (_, expr) => {
    usedNumber = true;
    return `formatAmountNumber(${expr.trim()})`;
  });
  s = s.replace(
    /([A-Za-z0-9_?.]+)\.toLocaleString\('en-IN', \{ minimumFractionDigits: 2, maximumFractionDigits: 2 \}\)/g,
    (match, expr) => {
      if (expr.startsWith('formatAmount')) return match;
      usedNumber = true;
      return `formatAmountNumber(${expr}, { minimumFractionDigits: 2 })`;
    },
  );
  s = s.replace(/([A-Za-z0-9_?.]+)\.toLocaleString\('en-IN'\)/g, (match, expr) => {
    if (expr.startsWith('formatAmount')) return match;
    usedNumber = true;
    return `formatAmountNumber(${expr})`;
  });

  if (usedNumber) s = addImport(s, 'formatAmountNumber');

  if (s !== orig) {
    fs.writeFileSync(file, s);
    inlineCount += 1;
    console.log('inline', path.relative(root, file));
  }
}

console.log({ helperCount, inlineCount });
