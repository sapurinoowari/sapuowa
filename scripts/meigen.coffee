# Description
#   A Hubot script that returns "偉人の名言100" from atsume.goo.ne.jp
#
# Configuration:
#   None
#
# Commands:
#   hubot meigen - retusn "偉人の名言100" from atsume.goo.ne.jp
#


IMAGE_LIST =
  'アリストテレス' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Aristotle_Altemps_Inv8575.jpg/400px-Aristotle_Altemps_Inv8575.jpg'
  '加賀見俊夫' : 'http://etutorend.com/wp-content/uploads/2014/12/growth_pic001.jpg'
  '夏目漱石' : 'https://upload.wikimedia.org/wikipedia/commons/1/17/Natsume_Soseki_photo.jpg'
  'メーソン・クーリー' : 'http://cslbook.com/wp-content/uploads/2015/07/matome_20140905154027_54095adb5987d.jpg'
  '野中日文' : 'http://cslbook.com/wp-content/uploads/2015/07/matome_20140905154027_54095adb5987d.jpg'
  'Ａ・シリトー' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/Alan_Sillitoe_%282009%29.jpg/400px-Alan_Sillitoe_%282009%29.jpg'
  '久保田美文' : 'http://cslbook.com/wp-content/uploads/2015/07/matome_20140905154027_54095adb5987d.jpg'
  'ギタ・ベリン' : 'http://cslbook.com/wp-content/uploads/2015/07/matome_20140905154027_54095adb5987d.jpg'
  '萩原朔太郎' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Hagiwara_Sakutaro.jpg/400px-Hagiwara_Sakutaro.jpg'
  'ブライアン・アダムス' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Bryan_Adams_Hamburg_MG_0631_flickr.jpg/440px-Bryan_Adams_Hamburg_MG_0631_flickr.jpg'
  'ジミー・コーナーズ' : 'https://upload.wikimedia.org/wikipedia/commons/6/62/Jimmy_Connors_cropped.jpg'
  'ゲーテ' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Goethe_%28Stieler_1828%29.jpg/400px-Goethe_%28Stieler_1828%29.jpg'
  '湯川秀樹' : 'https://upload.wikimedia.org/wikipedia/commons/7/7b/Yukawa.jpg'
  'チャップリン' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Charlie_Chaplin.jpg/470px-Charlie_Chaplin.jpg'
  'ホラティウス' : 'https://upload.wikimedia.org/wikipedia/commons/9/95/Quintus_Horatius_Flaccus.jpg'
  '河合隼雄' : 'http://www.kyotomm.jp/HP/newsTopicsImage/kancho_koen01.jpg'
  'シェイクスピア' : 'https://upload.wikimedia.org/wikipedia/commons/3/3c/CHANDOS3.jpg'
  'アインシュタイン' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Einstein1921_by_F_Schmutzer_2.jpg/450px-Einstein1921_by_F_Schmutzer_2.jpg'
  'エマーソン' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Ralph_Waldo_Emerson_ca1857_retouched.jpg/440px-Ralph_Waldo_Emerson_ca1857_retouched.jpg'
  'ダグ・マハーショルド' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Dag_Hammarskjold-2.jpg/400px-Dag_Hammarskjold-2.jpg'
  'マルコム・フォーブズ' : 'http://iso-labo.com/labo/images/words_of/MalcolmForbes/MalcolmForbes03.jpg'
  'カフカ' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Kafka.jpg/400px-Kafka.jpg'
  'マーフィー' : 'http://cdn-ak.f.st-hatena.com/images/fotolife/H/Haribo01/20151015/20151015234741.jpg'
  'ドン・シベット' : 'http://cslbook.com/wp-content/uploads/2015/07/matome_20140905154027_54095adb5987d.jpg'
  'エリノア・ルーズベルト' : 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Eleanor_Roosevelt_portrait_1933.jpg/440px-Eleanor_Roosevelt_portrait_1933.jpg'
  
  
# 名前からイメージURLの抽出
convertUrl = (url, image_list) ->
  if url of image_list
    url = image_list[url]
  return url
  
# 稲野さん
inanoUrl = (url, image_url) ->
  if url is image_url
    url = "https://scontent.cdninstagram.com/hphotos-xaf1/t51.2885-15/s640x640/sh0.08/e35/11809833_1048720578479066_148269723_n.jpg"
  return url

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
      image = convertUrl(meigen.name, IMAGE_LIST)
      image = inanoUrl(image,meigen.name)
      res.send "#{meigen.name}「#{meigen.text}」\n#{image}"