os = require 'os'
# 改行コード
EOL = os.EOL

setMassages = () ->
  helps = {}
  helps['asset'] = 'get info of crypt currency'
  helps

module.exports = (robot) ->
  robot.respond /commands/i, (bot) ->
    helps = setMassages()
    message = ''
    for command, description of helps
      message += ' `' + command + '` ' + description + EOL
    bot.send message
