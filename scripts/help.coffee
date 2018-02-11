os = require 'os'
# 改行コード
EOL = os.EOL

setMassages = () ->
  commands = []
  commands.push { command : "asset", description : 'get info of crypt currency' }
  commands.push { command : "wiki <word>", description : 'search <word> by wiki' }
  commands.push { command : "words <number>", description : 'show random words in wiki. number should be [1-9]' }
  commands

module.exports = (robot) ->
  robot.respond /commands/i, (bot) ->
    commands = setMassages()
    message = ''
    for val, index in commands
      message += ' `' + val.command + '` ' + val.description + EOL
    bot.send message
