'use strict';

const { writeFileSync } = require('fs');
const { execSync } = require('child_process');

const compilers = require('./compilers.json');

function execute(code, language, settings) {
  if (!process.env.DOCKER) {
    console.error('You should only run this in docker!');
    process.exit(1);
  }

  let compiler = compilers[language];
  if (!compiler) {
    console.log(`Unknown language "${language}"`);
    return;
  }

  compiler = {
    ...compiler,
    ...settings
  };
  let { input, output, compile, exec } = compiler;

  writeFileSync(input, code);

  if (compile) {
    try {
      execSync(
        compile.replace(/\$input\$/g, input || '').replace(/\$output\$/g, output || ''), { stdio: 'inherit' }
      );
    } catch {
      return '';
    }
  }

  try {
    execSync(
      exec.replace(/\$input\$/g, input || '').replace(/\$output\$/g, output || ''), { stdio: 'inherit' }
    );
  } catch {
    return '';
  }
}

let data = '';
process.stdin.on('data', chunck => {
  data += chunck;
});

process.stdin.on('end', () => {
  const { code, language, settings } = JSON.parse(data);
  execute(code, language, settings);
});
