const { Client } = require('discord.js');
const client = new Client();

const config = require('./config.json');
const evil = require('./index.js');

client.on('ready', () => console.log(`Logged in as ${client.user.tag} (${client.user.id})`));
client.on('error', console.error);

client.on('message', async msg => {
  if (msg.author.id !== '204156692760494080') return;
  if (!msg.content.startsWith('!')) return;

  let [language, ...code] = msg.content.slice(1).split(' ');

  let output;
  try {
    output = await evil(code.join(' '), language, { cpus: '0.5', memory: '25m' });
  } catch (err) {
    output = err;
  }

  if (output.length > 2000) {
    msg.reply('output too long');
    return;
  }

  msg.reply(output, { code: language });
});

client.login(config.token);
