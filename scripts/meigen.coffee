# Description
#   A Hubot script that returns "偉人の名言100" from atsume.goo.ne.jp
#
# Configuration:
#   None
#
# Commands:
#   hubot meigen - retusn "偉人の名言100" from atsume.goo.ne.jp
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  request = require 'request-b'
  cheerio = require 'cheerio'

  robot.respond /名言$/i, (res) ->
    url = 'http://atsume.goo.ne.jp/HxLFhNn4N7Zb'
    request(url).then (r) ->
      $ = cheerio.load r.body
      meigens = []
      $('#atsumeWrapper .section').each ->
        e = $ @
        name = e.find('h2').text().trim()
        text = e.find('p').text().trim()
        meigens.push { name, text }
      meigen = res.random meigens
      res.send "#{meigen.name}「#{meigen.text}」"