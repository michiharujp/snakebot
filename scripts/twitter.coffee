child_process = require 'child_process'

module.exports = (robot) ->
  robot.respond /tw (.*)/i, (bot) ->
    msg = res.match[1]
    bot.send msg
