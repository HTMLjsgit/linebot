class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'
  require 'date'
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
        elsif event.message['text']&.try!(:include?, "youtube") || event.message['text']&.try!(:include?, "ユーチューブ") || event.message['text']&.try!(:include?, "ゆーちゅーぶ")
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
        elsif event.message['text']&.try!(:include?, "じこしょうかい") || event.message['text']&.try!(:include?, "ねんれい") || event.message['text']&.try!(:include?, "なんさい") || event.message['text']&.try!(:include?, "とし") 
          response = "私はくろrailsまんのbotです。　年齢もありません　性別はありません。 ちょっとしたことしか話せません　申し訳ないとおもってます。"
        elsif event.message['text']&.try!(:include?, "せいべつは") || event.message['text']&.try!(:include?, "おとこ") || event.message['text']&.try!(:include?, "おんな")
          response = "私に性別などありません。 \n あなたがなんて思うかですかね。"
        elsif event.message['text']&.try!(:include?, "なんで") ||  event.message['text']&.try!(:include?, "理由は")
          response = "わかりません　ごめんなさい🙇"
        elsif event.message['text']&.try!(:include?, "あなた") ||  event.message['text']&.try!(:include?, "おまえ") ||  event.message['text']&.try!(:include?, "きみ")
          response = "なんですか？"
        elsif event.message['text'] == "あのさ"
          response = "はい！"
        elsif event.message['text']&.try!(:include?, "つかう")
          response = "なにをですか？"
        elsif event.message['text']&.try!(:include?, "へぇ") || event.message['text']&.try!(:include?, "へえ") || event.message['text']&.try!(:include?, "ほほう") || event.message['text']&.try!(:include?, "あの") || event.message['text']&.try!(:include?, "きいて") || event.message['text']&.try!(:include?, "きけ") || event.message['text']&.try!(:include?, "あっそ") || event.message['text']&.try!(:include?, "そう")
          response = "はい！"
        elsif event.message['text']&.try!(:include?, "いたい") || event.message['text']&.try!(:include?, "いた") 
          response = "大丈夫ですか？病院いきますか？"
        elsif event.message['text']&.try!(:include?, "だいじょうぶ") 
          response = "そうですか　よかったです"
        elsif event.message['text']&.try!(:include?, "つまんない") || event.message['text']&.try!(:include?, "つまらん") 
          response = "そうですか。。　それは大変申し訳ございません。"
        elsif event.message['text']&.try!(:include?, "つかれた") || event.message['text']&.try!(:include?, "つかれる")
          response = "お休みになられたほうがいいですよ。。"
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
        elsif event.message['text']&.try!(:include?, "けっこんして")
          response = "むりです"
        elsif event.message['text']&.try!(:include?, "おすすめ")
          response = "私おすすめのウェブサービス \n\n https://identweb.https://identweb.herokuapp.com"
        elsif event.message['text']&.try!(:include?, "は？")　|| event.message['text']&.try!(:include?, "は?")event.message['text']&.try!(:include?, "だまれ")　
          response = "すみません。。。"
        else
          response = "私　言葉を全く知らないんです #{event.message['text']}　ってなんですか？ \n \n [[  ちなみに漢字　用意されていない言葉　アルファベット　を返信した場合もこのメッセージが帰ってきます。 ひらがなで入力してください　 ]]"
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
