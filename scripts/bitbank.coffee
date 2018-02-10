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

# @todo 全通貨対応
module.exports = (robot) ->
  robot.respond /balance/i, (bot) ->
    bot.reply 'now you have'
    PRIVATE_API.getAsset().then (res) ->
      for asset, index in res.assets
        bot.reply asset.onhand_amount + ' ' + asset.asset
