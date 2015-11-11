comands = ["美人なう", "コスプレなう", "むらむらなう", "名言頼む", "ネタ募集", "ITネタ募集", "おもしろぼ", "@hubot 癒し"]

module.exports = (robot) ->
  robot.respond /コマンド教えて/i, (msg) ->
    for comand, index in comands
    	msg.send "#{comand}"