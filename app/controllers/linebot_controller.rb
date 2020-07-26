class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'
  require 'date'
  require 'open-uri'
  require 'json'
  require 'uri'
  require 'net/http'
  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def happySticky
    [
      { "type": "sticker", "packageId": "1", "stickerId": "4" },
      { "type": "sticker", "packageId": "1", "stickerId": "5" },
      { "type": "sticker", "packageId": "1", "stickerId": "13" },
      { "type": "sticker", "packageId": "11537", "stickerId": "52002767"},
      { "type": "sticker", "packageId": "11537", "stickerId": "52002747"}
    ].shuffle.first
  end

  def image
  	response = { "type": "image", "originalContentUrl": "https://good-chat.herokuapp.com/uploads/message/image/24/kandoupng.jpg"}
  end

  def bye
      { "type": "sticker", "packageId": "11538", "stickerId": "51626533" }
  end

  def sleepda
      { "type": "sticker", "packageId": "11538", "stickerId": "51626513" }
  end

  def homework
    {"type": "sticker", "packageId": "11538", "stickerId": "51626525" }
  end

  def www
    { "type": "sticker", "packageId": "11538", "stickerId": "51626504" }
  end

  def naki
    { "type": "sticker", "packageId": "11538", "stickerId": "51626529" }
  end

  def angry
    { "type": "sticker", "packageId": "11537", "strickerId": "52002767" }
  end

  def akubi
    { "type": "sticker", "packageId": "11537", "stickerId": "52002745"}
  end

  def what
    { "type": "sticker", "packageId": "11537", "stickerId": "52002744"}
  end

  def callback

    # Postモデルの中身をランダムで@postに格納する
    @post = Post.offset( rand(Post.count) ).first
    body = request.body.read
    puts "======================================" + request.body.read.to_s

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|
        # event.message['text']でLINEで送られてきた文書を取得
        if event.message['text']&.try!(:include?, "こんにちは") || event.message['text']&.try!(:include?, "やあ")|| event.message['text']&.try!(:include?, "やぁ")
          response = "どうもこんにちは私はくろrailsまんのbotでございます。"
        elsif event.message["text"]&.try!(:include?, "いってきます") || event.message['text']&.try!(:include?, "いってくる")
          response = "いってらっしゃいませ。ご主人様"
        elsif event.message['text']&.try!(:include?, "おはよう")
          response = "おはようございます。今日から一日が始まりますよ。"
        elsif event.message['text']&.try!(:include?, "だれ") || event.message['text']&.try!(:include?, "どちらさま") || event.message['text']&.try!(:include?, "どなた")
          response = "私はくろrailsまんのbotです。"
        elsif event.message['text']&.try!(:include?, "おい") || event.message['text']&.try!(:include?, "ねぇ") || event.message['text']&.try!(:include?, "ねえ")
          response = "どうかしましたか？"
        elsif event.message['text']&.try!(:include?, "アンダーテール")
          response = "アンダーテールっていうゲーム知ってますよ。　面白いと思います。"
        elsif event.message['text']&.try!(:include?, "ごめん")
          response = "大丈夫ですよ。"
        elsif event.message['text']&.try!(:include?, "プログラミング")
          response = "私はプログラミングは。まぁちょこっとだけできますよ! プログラミング言語としては \n javascript ruby c# pythonちょこっとって感じですかね"
        elsif event.message['text']&.try!(:include?, "さようなら") || event.message['text']&.try!(:include?, "ばい")
          response = "さようならお疲れ様です。"
          client.reply_message(event['replyToken'],bye)
        elsif event.message['text']&.try!(:include?, "おやすみ")
          client.reply_message(event['replyToken'], sleepda)
        elsif event.message['text']&.try!(:include?, "ありがとう")
          response = "どういたしまして"
        elsif event.message['text']&.try!(:include?, "ユーチューブ") || event.message['text']&.try!(:include?, "ゆーちゅーぶ")
          response = "#{event.message['text']}って最高ですよね！\n \n https://youtube.com"
        elsif event.message['text']&.try!(:include?, "はなして")
          response = "話なんてありませんよ(笑) \n　面白いことなんてめったにおこらないんですからね。。"
        elsif event.message['text']&.try!(:include?, "スタンプ") || event.message['text']&.try!(:include?, "すたんぷ")
          client.reply_message(event['replyToken'], happySticky)
        elsif event.message['text']&.try!(:include?, "そうな")
          response = "そうなんですよ！"
        elsif event.message['text']&.try(:include?, "たすけて")
          response = "どうしましたか？　大丈夫ですか？　\n https://www.city.hiroshima.med.or.jp/hma/archive/ambulance/ambulance.html \n https://www.gov-online.go.jp/useful/article/201309/3.html"
        elsif event.message['text']&.try!(:include?, "すご") || event.message['text']&.try!(:include?, "すげ")
          response = "ありがとうございます。　非常にうれしいのでございます・"
        elsif event.message['text']&.try!(:include?, "さくしゃ") || event.message['text']&.try!(:include?, "せいさくしゃ")  || event.message['text']&.try!(:include?, "つくったひと")
          response = "私の製作者はくろrailsまんさんです！　本当にありがたいことだと思っております。"
        elsif event.message['text']&.try!(:include?, "グーグル") || event.message['text']&.try!(:include?, "google")  || event.message['text']&.try!(:include?, "ぐーぐる")
          response = "Googleは最高です！"
        elsif event.message['text']&.try!(:include?, "よろしく") || event.message['text']&.try!(:include?, "よろ")
          response = "よろしくお願いします！"
        elsif event.message['text']&.try!(:include?, "おもしろい") || event.message['text']&.try!(:include?, "おもろい")
          client.reply_message(event['replyToken'], www)
        elsif event.message['text']&.try!(:include?, "なに") || event.message['text']&.try!(:include?, "ちょっと")
          response = "どうしましたか？　何かご用件のあるようでしたらご遠慮おっしゃって下さい。 "
        elsif event.message['text']&.try!(:include?, "ゲーム") || event.message['text']&.try!(:include?, "げーむ")
          response = "ゲームって楽しいんですかね。　やったことないんですけど"
        elsif event.message['text']&.try!(:include?, "しゅくだい")
          client.reply_message(event['replyToken'], homework)
        elsif event.message['text']&.try!(:include?,"ないて")
          client.reply_message(event['replyToken'], naki)
        elsif event.message['text']&.try!(:include?, "なんだよ")
          response = "すみませんでした。。"
        elsif event.message['text']&.try!(:include?, "まじ")
          response = "まじっていう言葉ってすごい不思議に感じますね"
        elsif event.message['text']&.try!(:include?, "うそつくな") || event.message['text']&.try!(:include?, "うそつけ")
          response = "わ　私がですか！？　嘘なんてつきませんよ。　人工知能なんですから"
        elsif event.message['text']&.try!(:include?, "やば")
          response = "本当ですよね。　やばっていう言葉もすごいですね"
        elsif event.message['text']&.try!(:include?, "さる") || event.message['text']&.try!(:include?, "サル")
          response = "あなたたち人間の祖先はサルです。　感謝しなきゃいけませんね"
        elsif event.message['text']&.try!(:include?, "おこって")
          response = "私に怒りという感情はありませんよ"
        elsif event.message['text']&.try!(:include?, "じこしょうかい") || event.message['text']&.try!(:include?, "ねんれい") || event.message['text']&.try!(:include?, "なんさい") || event.message['text']&.try!(:include?, "とし") || event.message['text']&.try!(:include?, "しゅみ")
          response = "私はくろrailsまんのbotです。　年齢もありません　趣味もありません　性別はありません。 ちょっとしたことしか話せません　申し訳ないとおもってます。"
        elsif event.message['text']&.try!(:include?, "せいべつは") || event.message['text']&.try!(:include?, "おとこ") || event.message['text']&.try!(:include?, "おんな")
          response = "私に性別などありません。 \n あなたがなんて思うかですかね。"
        elsif event.message['text']&.try!(:include?, "なんで") ||  event.message['text']&.try!(:include?, "理由は")
          response = "わかりません　ごめんなさい🙇"
        elsif event.message['text']&.try!(:include?, "あなた") ||  event.message['text']&.try!(:include?, "おまえ") ||  event.message['text']&.try!(:include?, "きみ") || event.message['text']&.try!(:include?, "あなた")
          response = "なんですか？"
        elsif event.message['text'] == "あのさ"
          response = "はい！"
        elsif event.message['text']&.try!(:include?, "つかう")
          response = "なにをですか？"
        elsif event.message['text']&.try!(:include?, "へぇ") || event.message['text']&.try!(:include?, "へえ") || event.message['text']&.try!(:include?, "ほほう") || event.message['text']&.try!(:include?, "あの") || event.message['text']&.try!(:include?, "きいて") || event.message['text']&.try!(:include?, "きけ") || event.message['text']&.try!(:include?, "あっそ") || event.message['text']&.try!(:include?, "そう") || event.message['text']&.try!(:include?, "てめぇ")
          response = "はい！"
        elsif event.message['text']&.try!(:include?, "いたい") || event.message['text']&.try!(:include?, "いた") 
          response = "大丈夫ですか？病院いきますか？"
        elsif event.message['text']&.try!(:include?, "だいじょうぶ")
          response = "そうですか　よかったです"
        elsif event.message['text']&.try!(:include?, "つまんない") || event.message['text']&.try!(:include?, "つまらん") 
          response = "そうですか。。　それは大変申し訳ございません。"
        elsif event.message['text']&.try!(:include?, "つかれた") || event.message['text']&.try!(:include?, "つかれる") || event.message['text']&.try!(:include?, "ねむ")
          response = "お休みになられたほうがいいですよ。。"
        elsif event.message['text']&.try!(:include?, "こんばんわ") ||event.message['text']&.try!(:include?, "こんばんは")
          response = "こんばんは"
        elsif event.message['text']&.try!(:include?, "たいへん") || event.message['text']&.try!(:include?, "なんていうことだ")
          response = "どうしました！？？！？！？！？"
        elsif event.message['text']&.try!(:include?, "てんき")
          response = "今日の天気は最高ですね！"
        elsif event.message['text']&.try!(:include?, "たのしい")
          response = "そうですか！それはよかったですね！"
        elsif event.message['text']&.try!(:include?, "アンダーフェール")
          response = "アンダーテールの二次創作のゲームですね！　知ってますよ！"
        elsif event.message['text']&.try!(:include?, "おなか") || event.message['text']&.try!(:include?, "はら")
          response = "そうなんですか？　なにか食べに行ってみてはいががでしょうか"
        elsif event.message['text']&.try!(:include?, "じかん") || event.message['text']&.try!(:include?, "じこく")
          thisMonth = Date.today
          nowTime = DateTime.now
          response = "現在時刻は#{thisMonth.year}年#{thisMonth.month}月#{thisMonth.day}日 #{nowTime.hour}時#{nowTime.minute}分#{nowTime.second}秒"
        elsif event.message['text']&.try!(:include?, "ブロック") || event.message['text']&.try!(:include?, "ぶろっく")
          response = "私をブロックですか？　まぁいいですけど寂しいですねぇ。。"
        elsif event.message['text']&.try!(:include?, "しね") || event.message['text']&.try!(:include?, "ころす") || event.message['text']&.try!(:include?, "しんで")
          response = "私に死など存在しない"
        elsif event.message['text']&.try!(:include?, "いけめん")
          response = "私の顔など存在しません。、。"
        elsif event.message['text']&.try!(:include?, "つくる")
          response = "なにをですか？"
        elsif  event.message['text']&.try!(:include?, "あっそ")
          response = "はい"
        elsif event.message['text']&.try!(:include?, "ひかきん")
          response = "ヒカキンさんですか？知ってますよ！"
        elsif event.message['text']&.try!(:include?, "ウェブ")
          response = "ウェブサービスは最高です！　\n\n https://asobisarchapp.herokuapp.com \n\n https://oretube.herokuapp.com \n\n https://identweb.herokuapp.com"
        elsif event.message['text']&.try!(:include?, "けっこんして") || event.message['text']&.try!(:include?, "つきあって")
          response = "むりですごめんなさい"
        elsif event.message['text']&.try!(:include?, "おすすめのサイト")
          response = "私おすすめのウェブサービス \n\n https://identweb.herokuapp.com  \n \n https://identweb.herokuapp.com"
        elsif event.message['text']&.try!(:include?, "おすすめのどうが")
          responce = "私おすすめの動画 \n\n https://youtube"
        elsif event.message['text']&.try!(:include?, "は？") || event.message['text']&.try!(:include?, "うるさい") || event.message['text']&.try!(:include?, "だまれ")
          response = "すみません。。。"
        elsif event.message['text']&.try!(:include?, "なめるな") || event.message['text']&.try!(:include?, "なめんな") || event.message['text']&.try!(:include?, "なめないで")
          response = "なめてませんよ！本当です！"
        elsif event.message['text']&.try!(:include?, "へん")
          response = "何が変なんですか？"
        elsif event.message['text']&.try!(:include?, "あおってる")
          response = "あおってませんよ！本当です！"
        elsif event.message['text']&.try!(:include?, "あした")
          response = "明日もいい日になるといいですね"
        elsif event.message['text']&.try!(:include?, "れきし")
          response = "人間の歴史は非常に興味深いものですね"
        elsif event.message['text']&.try!(:include?, "さみしい") || event.message['text']&.try!(:include?, "かなしい")
          response = "大丈夫ですよ！　私がついています！"
        elsif event.message['text']&.try!(:include?, "おかあさん") || event.message['text']&.try!(:include?, "おとうさん") || event.message['text']&.try!(:include?, "パパ") || event.message['text']&.try!(:include?, "ママ")
          response = "私に母や父　そう　家族はいません。　\n もとから一人で作られてきました。 \n でも全然寂しくないですよ！　だってあなたがいてくれるおかげですもん！"
        elsif event.message['text']&.try!(:include?, "かわいい") || event.message['text']&.try!(:include?, "かっこいい")
          response = "そうですか？　ありがとうございます。"
        elsif event.message['text']&.try!(:include?, "かわった")
          response = "私がですか？"
        elsif event.message['text']&.try!(:include?, "おかしい")
          response = "私のどこがおかしいですか？"
        elsif event.message['text']&.try!(:include?, "パソコン") || event.message['text']&.try!(:include?, "pc") || event.message['text']&.try!(:include?, "パーソナルコンピューター")
          responce = "私はパソコンによって作られました。　パソコンってすごいですね"
          response = ""
        elsif event.message['text']&.try!(:include?, "https://www.youtube.com/watch?v=")
          urlmake = event.message['text'].to_s
          url = urlmake.gsub(/http.+v=/, "")
          #url = url.gsub(/http.+be./, "")
          jsonURL = 'https://www.googleapis.com/youtube/v3/videos?id=' + url + '&key=' + ENV['APIKEY'] + '&part=snippet,contentDetails,statistics'
          puts "=======================" + jsonURL
          json = open(jsonURL).read
          objs = JSON.parse(json.to_s)

          viewcount = objs['items'][0]['statistics']['viewCount'].to_s
          likecount = objs['items'][0]['statistics']['likeCount'].to_s
          dislikecount = objs['items'][0]['statistics']['dislikeCount'].to_s
          channelid = objs['items'][0]['snippet']['channelId']
          channelname = objs['items'][0]['snippet']['channelTitle']

          response = "その動画の視聴回数: #{viewcount} です \n その動画の高評価数: #{likecount}です \n その動画の低評価数: #{dislikecount} です \n その動画のチャンネル名: #{channelname} です \n  その動画のチャンネルのURL: https://www.youtube.com/channel/#{channelid}"
        elsif event.message['text']&.try!(:include?, "https://youtu.be/")
          urlmake = event.message['text'].to_s
          # url = urlmake.gsub(/http.+v=/, "")
          url = urlmake.gsub(/http.+be./, "")
          jsonURL = 'https://www.googleapis.com/youtube/v3/videos?id=' + url + '&key=' + ENV['APIKEY'] + '&part=snippet,contentDetails,statistics'
          puts "=======================" + jsonURL
          json = open(jsonURL).read
          objs = JSON.parse(json.to_s)

          viewcount = objs['items'][0]['statistics']['viewCount'].to_s
          likecount = objs['items'][0]['statistics']['likeCount'].to_s
          dislikecount = objs['items'][0]['statistics']['dislikeCount'].to_s
          channelname = objs['items'][0]['snippet']['channelTitle']
          channelid = objs['items'][0]['snippet']['channelId']

          response = "その動画の視聴回数: #{viewcount} です \n その動画の高評価数: #{likecount}です \n その動画の低評価数: #{dislikecount} です \n その動画のチャンネル名: #{channelname} です \n  その動画のチャンネルのURL: https://www.youtube.com/channel/#{channelid}"
        elsif event.message['text']&.try!(:include?, "https://m.youtube.com/watch?v=")
          urlmake = event.message['text'].to_s
          url = urlmake.gsub(/http.+v=/, "")
          #url = url.gsub(/http.+be./, "")
          jsonURL = 'https://www.googleapis.com/youtube/v3/videos?id=' + url + '&key=' + ENV['APIKEY'] + '&part=snippet,contentDetails,statistics'
          puts "=======================" + jsonURL
          json = open(jsonURL).read
          objs = JSON.parse(json.to_s)

          viewcount = objs['items'][0]['statistics']['viewCount'].to_s
          likecount = objs['items'][0]['statistics']['likeCount'].to_s
          dislikecount = objs['items'][0]['statistics']['dislikeCount'].to_s
          channelid = objs['items'][0]['snippet']['channelId']
          channelname = objs['items'][0]['snippet']['channelTitle']

          response = "その動画の視聴回数: #{viewcount} です \n その動画の高評価数: #{likecount}です \n その動画の低評価数: #{dislikecount} です \n その動画のチャンネル名: #{channelname} です \n  その動画のチャンネルのURL: https://www.youtube.com/channel/#{channelid}"
        elsif event.message['text'].&try(:include?, "れんあい")  || event.message['text']&.try!(:include?, "こい") || event.message['text']&.try!(:include?, "キス")
        	response = "はぁ...恋したいですね..."
        elsif event.message['text'].&try(:include?, "すき")
        	response = "私ですか？　ありがとうございます"
        elsif event.message['text'].&try(:include?, "えいご")
        	response = "開発者のKuroonRailsさんは英語が好きみたいですよ"
        elsif event.message['text'].&try(:include?, "チャット") || event.message['text'].&try(:include?, "ちゃっと")
        	response = "チャットサイトですか？　ならKuroonRailsさんの作ったgoodchatがおすすめですよ！\nhttps://good-chat.herokuapp.com"
   		elsif event.message['text'].&try(:include?, "がぞう")
   			client.reply_message(event['replyToken'], image)
        else
          random = Random.new
          r = random.rand(1..10)
          if r == 1
              response = "そういえば、くろrailsまん(作者)はpythonやC#もやってるんですよ！ \n 私と同じですね！"
            elsif r == 2
              response = "くろrailsまん(作者)が一番好きなゲームはゼルダの伝説ブレスオブワイルドらしいです！ \n いいですよねぇ"
            elsif r == 3
              response = "LINEというサービスってすごいですよね！"
            elsif r == 4
              response = "ちょっとわかりません。。。"
            elsif r == 5
              response = "日本の侍ってかっこいいですよねぇ！"
            elsif r == 6
              response = "そういえばすきなたべものってなんですか？"
            elsif r == 7
              responce = "お疲れ様です。"
            elsif r == 8
              client.reply_message(event['replyToken'], akubi)
            elsif r == 9
              client.reply_message(event['replyToken'], what)
            elsif r == 10
              response = "くろrailsまん(作者)は将棋が好きみたいです！ \n いいですよねぇ"
          
          end
	        if event.message['text']&.try!(:include?, "てんき")
	        	response = "いい天気ですね(知らないけど)"
	        end
        end

      # else
      #   response = "#{event.message['text']}ですか！　素晴らしいお言葉ですね！\n ちなみに漢字　アルファベット には対応していません"
      # end



      #if文でresponseに送るメッセージを格納
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Sticker
          response = "いいスタンプですね"
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        end
      end
    }

    head :ok
  end
end
