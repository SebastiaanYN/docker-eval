'use strict';

const { spawn, execSync } = require('child_process');
const crypto = require('crypto');

const CONTAINER_NAME = 'docker-evaluate';

function evaluate(code, language, {
  settings = {},
  cpus,
  memory,
  net = 'none',
  name = crypto.randomBytes(5).toString('hex')
} = {}) {
  return new Promise((resolve, reject) => {
    name = `evaluate-${name}`;
    const args = ['run', '-i', '--rm', `--net=${net}`, `--name=${name}`];

    if (cpus) {
      args.push(`--cpus=${cpus}`);
    }

    if (memory) {
      args.push(`-m=${memory}`);
    }

    args.push(CONTAINER_NAME);
    const docker = spawn('docker', args);

    const timeout = setTimeout(() => {
      try {
        execSync(`docker kill --signal=9 ${name}`);
        reject(new Error('timeout'));
      } catch (err) {
        reject(err);
      }
    }, 20 * 1000);

    docker.stdin.write(JSON.stringify({ code, language, settings }));
    docker.stdin.end();

    let data = '';
    docker.stdout.on('data', chunck => {
      data += chunck;
    });

    docker.stderr.on('data', chunck => {
      data += chunck;
    });

    docker.on('error', reject);

    docker.on('exit', code => {
      clearTimeout(timeout);
      if (code === 0) {
        resolve(data);
      } else {
        reject(data);
      }
    });
  });
}

module.exports = evaluate;
