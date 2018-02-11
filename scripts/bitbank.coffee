# 余計なCommit
# Description
#   仮想通貨の情報をお伝えする
# 環境変数の設定
# BITBANK_API_KEY=@@@@@@
# BITBANK_API_SECRET=@@@@@@

# bitbankを使用する
BITBANK = require 'node-bitbankcc'

# bitbank public APIを使用する
PUBLIC_API = BITBANK.publicApi()

# bitbank private APIを使用する
PRIVATE_API = BITBANK.privateApi process.env.BITBANK_API_KEY, process.env.BITBANK_API_SECRET

#  利用可能なフィアット一覧
fiats = ['btc_jpy', 'xrp_jpy', 'ltc_btc', 'eth_btc', 'mona_jpy', 'mona_btc', 'bcc_jpy', 'bcc_btc']

module.exports = (robot) ->
  robot.respond /balance/i, (bot) ->
    PRIVATE_API.getAsset().then (res) ->
      for asset, index in res.assets
        bot.send asset.onhand_amount + ' ' + asset.asset

# @todo 通貨処理dry
# xrpの表示
  robot.respond /xrp/i, (bot) ->
    PRIVATE_API.getAsset().then (res) ->
      for asset, index in res.assets
        if asset.asset is 'xrp'
          bot.send ' amount: ' + asset.onhand_amount + ' ' + asset.asset
          PUBLIC_API.getTicker('xrp_jpy').then (value) ->
            bot.send 'xrp_jpy: ' + value.last + ' jpy'
            sum = value.last * asset.onhand_amount
            bot.send '    sum: ' + sum + ' jpy'
          break

# ethの表示
  robot.respond /eth/i, (bot) ->
    PRIVATE_API.getAsset().then (res) ->
      for asset, index in res.assets
        if asset.asset is 'eth'
          bot.send ' amount: ' + asset.onhand_amount + ' ' + asset.asset
          PUBLIC_API.getTicker('eth_btc').then (eth_btc) ->
            PUBLIC_API.getTicker('btc_jpy').then (btc_jpy) ->
              eth_jpy = eth_btc.last * btc_jpy.last
              bot.send 'eth_jpy: ' + eth_jpy + ' jpy'
              sum = eth_jpy * asset.onhand_amount
              bot.send '    sum: ' + sum + ' jpy'
          break
