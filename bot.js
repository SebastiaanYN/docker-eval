const { Client, RichEmbed } = require('discord.js');
const client = new Client();

const config = require('./config.json');
const compilers = require('./compilers.json');
const evil = require('./index.js');

const PREFIX = '!';

client.on('ready', () => console.log(`Logged in as ${client.user.tag} (${client.user.id})`));
client.on('error', console.error);

client.on('message', async msg => {
  if (!msg.content.startsWith(PREFIX)) return;

  if (msg.content.startsWith(`${PREFIX}languages`)) {
    const embed = new RichEmbed()
      .setTitle('Languages')
      .setDescription(
        Object.entries(compilers)
        .sort(([a], [b]) => a > b ? 1 : -1)
        .map(([name, info]) => `**${name}**: ${info.names.join(', ')}`)
      )
      .setColor('#4f86f7');

    msg.channel.send(embed);
    return;
  }

  let [language, ...code] = msg.content.slice(PREFIX.length).split(' ');
  code = code.join(' ').replace(/(^(?:```(?:\w+?)(?:\r?\n))|(```))|(```$)/g, '').trim();

  let output;
  try {
    output = await evil(code, language, { cpus: '0.5', memory: '250m' });
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
