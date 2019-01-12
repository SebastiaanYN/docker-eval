'use strict';

const { writeFileSync } = require('fs');
const { execSync } = require('child_process');

const compilers = require('./compilers.json');

function execute(code, language) {
  if (!process.env.DOCKER) {
    console.error('You should only run this in docker!');
    process.exit(1);
  }

  const compiler = compilers[language];
  if (!compiler) return `Unknown language "${language}"`;

  writeFileSync(compiler.file, code);
  try {
    return execSync(compiler.exec).toString();
  } catch {
    return '';
  }
}

let data = '';
process.stdin.on('data', chunck => {
  data += chunck;
});

process.stdin.on('end', () => {
  const { code, language } = JSON.parse(data);
  const output = execute(code, language);
  console.log(output);
});
