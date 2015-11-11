# Description
#   A Hubot script that returns "NAVERまとめ" from matome.naver.jp
#
# Configuration:
#   None
#
# Commands:
#   hubot ネタ募集
#
CronJob = require('cron').CronJob
URL_LIST = [
      "http://matome.naver.jp/topic/1Hipv" #ネタ
      "http://matome.naver.jp/topic/1Hipx" #ITニュース
      "http://matome.naver.jp/topic/1Luuv" #どうしてこうなった
      "http://matome.naver.jp/topic/1Hipw" #ネットで話題
      "http://matome.naver.jp/topic/1Hilh" #これはすごい
      "http://matome.naver.jp/topic/1Hipr" #雑学
      "http://matome.naver.jp/topic/1HipF" #恋愛
      "http://matome.naver.jp/topic/1Lw9Z" #なにこれほしい
      "http://matome.naver.jp/topic/1Hiq3" #iPhone
      "http://matome.naver.jp/topic/1Hioj" #猫
      "http://matome.naver.jp/topic/1HioI" #一人暮らし
      "http://matome.naver.jp/topic/1HinO" #美人
      "http://matome.naver.jp/topic/1M7Zv" #社会ニュース
    ]

# ランダム値を生成
random = (n) -> Math.floor(Math.random() * n)

module.exports = (robot) ->
  request = require 'request-b'
  cheerio = require 'cheerio'

  sendSlack = (neta) ->
    robot.send {room: "neta"}, "#{neta.name}\n#{neta.url}", null, true, "Asia/Tokyo"

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

  neta_job = new CronJob('0 00 18 * * 1-5', () =>
    url = URL_LIST[random(URL_LIST.length)]
    request(url).then (r) ->
      $ = cheerio.load r.body
      netas = []
      $('.mdTopicBoard01Sub01 .mdMTMTtlList02Txt a').each ->
        e = $ @
        url = e.attr('href')
        name = e.text()
        netas.push { url, name }
      neta = netas[random(netas.length)]
      sendSlack neta
  )
  neta_job.start()