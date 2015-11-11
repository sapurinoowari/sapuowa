comands = ["おもしろぼ", "test", "hogehoge"]

module.exports = (robot) ->
  robot.respond /コマンド教えて/i, (msg) ->
    for comand, index in comands
    	msg.send "#{comand}"