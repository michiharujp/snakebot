# Description
#   仮想通貨の情報をお伝えする
# 環境変数の設定
# BITBANK_API_KEY=@@@@@@
# BITBANK_API_SECRET=@@@@@@

# asyncの有効化
async = require 'async'

# bitbankを使用する
BITBANK = require 'node-bitbankcc'

# bitbank public APIを使用する
PUBLIC_API = BITBANK.publicApi()

# bitbank private APIを使用する
PRIVATE_API = BITBANK.privateApi process.env.BITBANK_API_KEY, process.env.BITBANK_API_SECRET

#  利用可能なフィアット一覧
fiats = ['btc_jpy', 'xrp_jpy', 'ltc_btc', 'eth_btc', 'mona_jpy', 'mona_btc', 'bcc_jpy', 'bcc_btc']

# jpy建可能な通貨一覧
jpys = ['btc', 'xrp', 'mona', 'btc']

# balanceは以下の形を目指す
# balance = {
#   'xrp' : {
#     'amount' : 1800,
#     'value' : 102,
#    },
#    'eth' : {
#      'amount' : 2,
#      'value' : 90000,
#    }
# }
balance = {}

# balanceを整形するメソッド
getBalance = ->
  funcs = []
  funcs.push PRIVATE_API.getAsset()
  for fiat, index in fiats
    funcs.push PUBLIC_API.getTicker(fiat)
  Promise.all(funcs).then (res) ->
    for asset, index in res[0].assets
      if asset.asset is 'jpy'
        continue
      balance[asset.asset] = {}
      balance[asset.asset]['amount'] = asset.onhand_amount
    res.shift()
    trade_info = {}
    for fiat, index in res
      trade_info[fiats[index]] = fiat.last

    total_sum = 0
    for name, amount of balance
      if name is 'jpy'
        continue
      if jpys.includes name
        balance[name]['value'] = trade_info[name + '_jpy']
      else
        balance[name]['value'] = trade_info[name + '_btc'] * trade_info['btc_jpy']

      balance[name]['sum'] = balance[name]['amount'] * balance[name]['value']
      total_sum += balance[name]['sum']

    # 丸め
    for asset_key, asset of balance
      for key, value of asset
        balance[asset_key][key] = Math.floor(balance[asset_key][key] * 100) / 100
    total_sum = Math.floor total_sum

    Promise.resolve([ balance, total_sum ])

module.exports = (robot) ->

  robot.respond /asset/i, (bot) ->
    getBalance().then (res) ->
      bot.send 'name | amount | value | sum'
      for name, data of res[0]
        bot.send name + ' | ' + data['amount'] + ' | ' + data['value'] + ' | ' + data['sum']
      bot.send 'total asset is ' + res[1] + 'jpy'
