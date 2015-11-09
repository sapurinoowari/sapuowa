# Description:
#   Hubot responds current time bijin-tokei URL
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot bijin now - Hubot responds bijin-tokei URL of 'all japan'
#   美人なう - 'hubot bijin now'と同じ。
#   hubot bijin now [local] - Hubot responds bijin-tokei URL of 'local'
#   美人なう、[local] - 'hubot bijin now [local]'と同じ。
#
# Notes:
#   システムのタイムゾーンに関わらず、日本時間の時刻を返す。
#   [local]を日本語で指定することができる。
#   「美人なう(、[local])」は、Hubotに対する呼びかけでなくても反応する。
#   IMEがONの場合に「美人なう、[日本語local]」で入力することを想定している。
#
# Author:
#   succi0303
#
CronJob = require('cron').CronJob

BASE_URL = 'http://www.bijint.com/assets/pict'
BASE_COS_URL = 'http://costime.jp/img/clock/1'
BASE_AV_URL = 'http://www.avtokei.jp/images/clocks'
AV_KEY = '?1422254178'
PICT_EXT = 'jpg'
joblist = [
      "osaka"
      "hokkaido"
      "sendai"
      "kobe"
      "fukuoka"
	  "kanazawa"
      "nagoya"
	  "gunma"
      "fukui"
      "okinawa"
      "kumamoto"
      "saitama"
	  "tokyo"
      "shizuoka"
	  "miyazaki"
      "iwate"
      "tochigi"
      "kanagawa"
      "fukuoka"
	  "kanazawa"
      "kyoto"
	  "okayama"
      "nagasaki"
      "akita"
      "nagano"
      "ibaraki"
	  "saga"
      "aomori"
	  "kagawa"
      "kagoshima"
      "niigata"
      "hiroshima"
	  "chiba"
      "nara"
	  "yamaguchi"
      "tottori"
      "yamanashi"
      "tokushima"
      "cc"
      "bimajo"
      "hairstyle"
      "vivi"
      "sara"
      "hanayome"
      "megane"
      "mask-bijin"
      "idol"
      "taiwan"
      "thailand"
      "hawaii"
      "jakarta"
    ]
LOCAL_CONVERT_LIST =
  '大阪' : 'osaka'
  '北海道' : 'hokkaido'
  '宮城' : 'sendai'
  '兵庫' : 'kobe'
  '福岡' : 'fukuoka'
  '石川' : 'kanazawa'
  '愛知' : 'nagoya'
  '群馬' : 'gunma'
  '福井' : 'fukui'
  '沖縄' : 'okinawa'
  '熊本' : 'kumamoto'
  '埼玉' : 'saitama'
  '東京' : 'tokyo'
  '静岡' : 'shizuoka'
  '宮崎' : 'miyazaki'
  '岩手' : 'iwate'
  '栃木' : 'tochigi'
  '神奈川' : 'kanagawa'
  '京都' : 'kyoto'
  '岡山' : 'okayama'
  '長崎' : 'nagasaki'
  '秋田' : 'akita'
  '長野' : 'nagano'
  '茨城' : 'ibaraki'
  '佐賀' : 'saga'
  '青森' : 'aomori'
  '香川' : 'kagawa'
  '鹿児島' : 'kagoshima'
  '新潟' : 'niigata'
  '広島' : 'hiroshima'
  '千葉' : 'chiba'
  '奈良' : 'nara'
  '山口' : 'yamaguchi'
  '鳥取' : 'tottori'
  '山梨' : 'yamanashi'
  '徳島' : 'tokushima'
  '美男' : 'binan'
  'マッチョ' : 'macho'
  'サーキット' : 'cc'
  '美魔女' : 'bimajo'
  'キッズ' : 'kids'
  'ヘアスタイル' : 'hairstyle'
  'キッズ2' : 'kids-photostudio'
  'VIVI' : 'vivi'
  'SARA' : 'sara'
  'パナホーム兵庫' : 'panahome-hyogo'
  '早稲田スタイル' : 'wasedastyle'
  '花嫁' : 'hanayome'
  'キッズ3' : 'kids-fo'
  'メガネ' : 'megane'
  'キッズ4' : 'kids-babydoll'
  'マスク' : 'mask-bijin'
  'アイドル' : 'idol'  
  '2011' : '2011jp'
  '2012' : '2012jp'
  '2013' : '2013jp'
  '台湾' : 'taiwan'
  'タイ' : 'thailand'
  'ハワイ' : 'hawaii'
  'ジャカルタ' : 'jakarta'

# Dateオブジェクトを受け取り、日本時間の時・分のオブジェクトを返す。
nowTime = (date) ->
  t = date.getUTCHours() + 9
  if t < 24
    h = t
  else
    h = t % 24
  m = date.getMinutes()
  time = {
    hours: h
    minutes: m
  }
  return time

# Dateオブジェクトを受け取り、日本時間の時刻を"HH時MM分"の形式で返す。
strTime = (date) ->
  time = nowTime(date)
  hh = ('0' + time.hours).slice(-2)
  mm = ('0' + time.minutes).slice(-2)
  return "#{hh}時#{mm}分"

# Dateオブジェクトを受け取り、日本時間の時刻を"HHMM"の形式で返す。
hhmmTime = (date) ->
  time = nowTime(date)
  hh = ('0' + time.hours).slice(-2)
  mm = ('0' + time.minutes).slice(-2)
  return hh + mm
  
# AVDateオブジェクトを受け取り、日本時間の時刻を"HHMM"の形式で返す。
hhTime = (date) ->
  time = nowTime(date)
  hh = ('0' + time.hours).slice(-2)
  return hh


# 文字列と変換リストを受け取り、文字列がリストに該当する場合、文字列を変換して返す。
convertLocal = (local, conv_list) ->
  if local of conv_list
    local = conv_list[local]
  return local

# ランダム値を生成
random = (n) -> Math.floor(Math.random() * n)

get_msg = () ->
  date = new Date
  localSignature = joblist[random(joblist.length)]
  message = "今日は#{localSignature}から#{strTime(date)}をお知らせします。"
  image_url = "#{BASE_URL}/#{localSignature}/pc/#{hhmmTime(date)}.#{PICT_EXT}"
  return  "#{message}\n#{image_url}"

module.exports = (robot) ->
  robot.respond /bijin\s+now$/i, (msg) ->
    date = new Date
    message = "現在の時刻は#{strTime(date)}です。[全国版]"
    image_url = "#{BASE_URL}/jp/pc/#{hhmmTime(date)}.#{PICT_EXT}"
    msg.send "#{message}\n#{image_url}"

  robot.hear /美人なう$/, (msg) ->
    date = new Date
    localSignature = 'jp'
    message = "現在の時刻は#{strTime(date)}です。[全国版]"
    image_url = "#{BASE_URL}/#{localSignature}/pc/#{hhmmTime(date)}.#{PICT_EXT}"
    msg.send "#{message}\n#{image_url}"

  robot.respond /bijin\s+now\s+(.+)$/i, (msg) ->
    date = new Date
    localSignature = convertLocal(msg.match[1], LOCAL_CONVERT_LIST)
    message = "現在の時刻は#{strTime(date)}です。[地域版: #{localSignature}]"
    image_url = "#{BASE_URL}/#{localSignature}/pc/#{hhmmTime(date)}.#{PICT_EXT}"
    msg.send "#{message}\n#{image_url}"

  robot.hear /美人なう、(.+)$/, (msg) ->
    date = new Date
    localSignature = convertLocal(msg.match[1], LOCAL_CONVERT_LIST)
    message = "現在の時刻は#{strTime(date)}です。[地域版: #{localSignature}]"
    image_url = "#{BASE_URL}/#{localSignature}/pc/#{hhmmTime(date)}.#{PICT_EXT}"
    msg.send "#{message}\n#{image_url}"
	
  robot.respond /封印中むらむらなう$/, (msg) ->
    date = new Date
    message = "現在の時刻は#{strTime(date)}です。[R-18]"
    image_url = "#{BASE_AV_URL}/#{hhTime(date)}/#{hhmmTime(date)}.#{PICT_EXT}#{AV_KEY}"
    msg.send "#{message}\n#{image_url}"

  robot.hear /コスプレなう$/, (msg) ->
    date = new Date
    message = "現在の時刻は#{strTime(date)}です。[コスプレ]"
    image_url = "#{BASE_COS_URL}/#{hhmmTime(date)}.#{PICT_EXT}"
    msg.send "#{message}\n#{image_url}"

  robot.hear /時報なう$/, (msg) ->  
    msg.send get_msg()

  bijin_job = new CronJob('0 00 17 * * 1-5', () =>
    robot.send {room: "#bijin"}, get_msg(), null, true, "Asia/Tokyo"
  )
  bijin_job.start()