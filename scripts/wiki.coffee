os = require 'os'
# 改行コード
EOL = os.EOL


# GET用のライブラリ
request = require 'superagent'

# 同期用のライブラリ
async = require 'async'

# wikiのapiへのURL
WIKIPEDIA_URL = 'https://ja.wikipedia.org/wiki/'

module.exports = (robot) ->
  robot.respond /wiki (.*)/i, (bot) ->
    word = bot.match[1]
    request
      .get 'https://ja.wikipedia.org/w/api.php'
      .query {
        format : 'json',
        action : 'query',
        prop   : 'extracts',
        exintro: true,
        explaintext: true,
        titles : word
      }
      .end (err, res) ->
        query = res.body.query
        for key, val of query.pages
          content = val.extract
        if (content)
          content = '> ' + content.replace /\n/g, EOL + '> '
          content += EOL + WIKIPEDIA_URL + word
        else
          content = '見つからなかったよ。 ｼｬｰ!!'
        bot.send content

  robot.respond /words ([1-9])/i, (bot) ->
    ids = []
    num = bot.match[1]
    request
      .get 'https://ja.wikipedia.org/w/api.php'
      .query {
        format : 'json',
        action : 'query',
        list   : 'random',
        exsectionformat : 'raw',
        rnlimit: num,
        rnnamespace : 0,
      }
      .end (err, res) ->
        content = []
        for val, index in res.body.query.random
          ids.push val.id
        async.each ids, (id, callback) ->
          request
            .get 'https://ja.wikipedia.org/w/api.php'
            .query {
              format : 'json',
              action : 'query',
              prop   : 'extracts',
              exintro: true,
              explaintext: true,
              pageids : id
            }
            .end (err, res) ->
              page = res.body.query.pages[id]
              content.push {title : page.title, extract : page.extract }
              callback()
        , (err) ->
          message = ''
          for val, index in content
          # titleは太字
            message += '*' + val.title + '*' + EOL
            message += '> ' + val.extract.replace /\n/g, EOL + '> '
            message += EOL
          bot.send message
