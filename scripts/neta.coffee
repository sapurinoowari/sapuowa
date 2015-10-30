# Description
#   A Hubot script that returns "NAVERまとめ" from matome.naver.jp
#
# Configuration:
#   None
#
# Commands:
#   hubot ネタ募集
#

module.exports = (robot) ->
  request = require 'request-b'
  cheerio = require 'cheerio'

  robot.respond /ネタ募集$/i, (res) ->
    url = 'http://matome.naver.jp/topic/1Hipv'
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