class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'
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
      { "type": "sticker", "packageId": "11538", "stickerId": "52114121" }
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
      puts "=============================" + event.message['text']
        if event.message['text'].to_s.include?("こんにちは") || event.message['text'].include?("やぁ") || event.message['text'].include?("やあ")
          response = "どうもこんにちは私はくろrailsまんのbotでございます。"
        end
        if event.message["text"].to_s.include?("いってきます")
          response = "いってらっしゃいませ。ごしゅじんさま"
        end
        if event.message['text'].to_s.include?("おはよう")
          response = "おはようございます。今日から一日が始まりますよ。"
        end
        if event.message['text'].to_s.include?("だれ")
          response = "私はくろrailsまんのbotです。"
        end
        if event.message['text'].to_s.include?("おい") || event.message['text'].include?("ねぇ") || event.message['text'].include?("ねえ") || event.message['text'].include?("あのさ")
          response = "どうかしましたか？"
        end
        if event.message['text'].to_s.include?("あんだーてーる") || event.message['text'].include?("アンダーテール") || event.message['text'].include?("undertale")
          response = "アンダーテールっていうゲーム知ってますよ。　面白いと思います。"
        end

        if event.message['text'].to_s.include?("ごめん")
          response = "大丈夫ですよ。"
        end

        if event.message['text'].to_s.include?("プログラミングできる")
          response = "私はプログラミングは。まぁちょこっとだけできますよ! プログラミング言語としては \n javascript ruby c# pythonちょこっとって感じですかね"
        end
        if event.message['text'].to_s.include?("さようなら")
          response = "さようならお疲れ様です。"
          client.reply_message(event['replyToken'],bye)
        end
        if event.message['text'].to_s.include?("おやすみ")

          client.reply_message(event['replyToken'], sleepda)
          response = "おやすみなさい。起きた後も頑張りましょう"
        end
        if event.message['text'].to_s.include?("ありがとう") || event.message['text'].include?("ありがたい")
          response = "どういたしまして"
        end
        if event.message['text'].to_s.include?("youtube") || event.message['text'].include?("ユーチューブ") || event.message['text'].include?("ゆーちゅーぶ")
          response = "#{event.message['text']}って最高ですよね！\n \n https://youtube.com"
        end
        if event.message['text'].to_s.include?("はなしして")
          response = "話なんてありませんよ(笑) \n　面白いことなんてめったにおこらないんですからね。。"
        end
        if event.message['text'].to_s.include?("スタンプ") || event.message['text'].include?("すたんぷ")
          client.reply_message(event['replyToken'], happySticky)
        end
        if event.message['packageId'].to_s.include?(event.message['packageId'])
          response = "いいスタンプですね"
        end
        if event.message['text'].to_s.include?("そうな")
          response = "そうなんですよ！"
        end
        if event.message['text'].to_s.include?("たすけ")
          response = "どうしましたか？　大丈夫ですか？　\n https://www.city.hiroshima.med.or.jp/hma/archive/ambulance/ambulance.html \n https://www.gov-online.go.jp/useful/article/201309/3.html"
        end
        if event.message['text'].to_s.include?("すご")
          response = "ありがとうございます。　非常にうれしいのでございます・"
        end
        if event.message['text'].to_s.include?("さくしゃ")
          response = "私の製作者はくろrailsまんさんです！　本当にありがたいことだと思っております。"
        end
        if event.message['text'].to_s.include?("グーグル")
          response = "Googleは最高です！"
        end
        if event.message['text'].to_s.include?("よろしく")
          response = "よろしくお願いします！"
        end
        if event.message['text'].to_s.include?("おもしろい")
          client.reply_message(event['replyToken'], www)
        end
        if event.message['text'].to_s.include?("なに")
          response = "どうしましたか？　何かご用件のあるようでしたらご遠慮おっしゃって下さい。 "
        end
        if event.message["text"].to_s.include?("ゲーム")
          response = "ゲームって楽しいんですかね。　やったことないんですけど"
        end
        if event.message['text'].to_s.include?("しゅくだい")
          client.reply_message(event['reply_message'], homework)
        end
        if event.message['text'].to_s.include?("ないて")
          client.reply_message(event['reply_message'], naki)
        end
      # else
      #   response = "#{event.message['text']}ですか！　素晴らしいお言葉ですね！\n ちなみに漢字　アルファベット には対応していません"
      # end



      #if文でresponseに送るメッセージを格納
      case event
      when Line::Bot::Event::Message
        case event.type
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
