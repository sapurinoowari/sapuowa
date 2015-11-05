# Description
#   A Hubot script that returns "NAVERまとめ" from matome.naver.jp
#
# Configuration:
#   None
#
# Commands:
#   hubot ネタ募集
#

URL_LIST = [
      "http://matome.naver.jp/topic/1Hipv" #ネタ
      "http://matome.naver.jp/topic/1Hipx" #ITニュース
      "http://matome.naver.jp/topic/1Lvr8" #浮気・不倫
      "http://matome.naver.jp/topic/1Hipw" #ネットで話題
      "http://matome.naver.jp/topic/1Hilh" #これはすごい
      "http://matome.naver.jp/topic/1Hipr" #雑学
      "http://matome.naver.jp/topic/1HipF" #恋愛
      "http://matome.naver.jp/topic/1Lw9Z" #なにこれほしい
      "http://matome.naver.jp/topic/1LuzE" #事件・事故
      "http://matome.naver.jp/topic/1Hioj" #猫
      "http://matome.naver.jp/topic/1HioI" #一人暮らし
      "http://matome.naver.jp/topic/1HinO" #美人
      "http://matome.naver.jp/topic/1M0hB" #恋愛テクニック
    ]

# ランダム値を生成
random = (n) -> Math.floor(Math.random() * n)

module.exports = (robot) ->
  request = require 'request-b'
  cheerio = require 'cheerio'

  robot.hear /ネタ募集$/i, (res) ->
    url = URL_LIST[random(URL_LIST.length)]
    request(url).then (r) ->
      $ = cheerio.load r.body
      netas = []
      $('.mdTopicBoard01Sub01 .mdMTMTtlList02Txt a').each ->
        e = $ @
        url = e.attr('href')
        name = e.text()
        netas.push { url, name }
      neta = res.random netas
      res.send "#{neta.name}\n#{neta.url}"

  robot.respond /ITネタ募集$/i, (res) ->
    url = 'http://matome.naver.jp/topic/1Hipx'
    request(url).then (r) ->
      $ = cheerio.load r.body
      netas = []
      $('.mdTopicBoard01Sub01 .mdMTMTtlList02Txt a').each ->
        e = $ @
        url = e.attr('href')
        name = e.text()
        netas.push { url, name }
      neta = res.random netas
      res.send "#{neta.name}\n#{neta.url}"

# 未完成 
  robot.respond /もっとネタ募集$/i, (res) ->
    url = 'http://nlab.itmedia.co.jp/'
    request(url).then (r) ->
      $ = cheerio.load r.body
      motto_netas = []
      $('#colBoxIndex .colBoxTitle a').each ->
        e = $ @
        url = e.attr('href')
        title = e.attr('title')
        netas.push { url, title }
      motto_neta = res.random motto_netas
      res.send "#{motto_neta.title}\n#{motto_neta.url}"