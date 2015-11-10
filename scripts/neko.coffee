module.exports = (robot) ->
  robot.respond /(neko|猫|ねこ|(癒|いや)し)/i, (msg) ->
    robot.http("https://api.vineapp.com/timelines/users/1074021314932912128")
      .get() (err, res, body) ->
        records = JSON.parse(body)['data']['records']
        nekos = []
        for record in records
           nekos.push(record.shareUrl)
        msg.send msg.random nekos