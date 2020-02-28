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
  ].shuffle.first
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
      if event.message['text'].include?("こんにちは") || event.message['text'].include?("やぁ") || event.message['text'].include?("やあ")
        response = "どうもこんにちは私はくろrailsまんのbotでございます。"
      elsif event.message["text"].include?("いってきます")
        response = "いってらっしゃいませ。ごしゅじんさま"
      elsif event.message['text'].include?("おはよう")
        response = "おはようございます。今日から一日が始まりますよ。"
      elsif event.message['text'].include?("だれ")
        response = "私はくろrailsまんのbotです。"
      elsif event.message['text'].include?("おい") || event.message['text'].include?("ねぇ") || event.message['text'].include?("ねえ") || event.message['text'].include?("あのさ")
        response = "どうかしましたか？"
      elsif event.message['text'].include?("あんだーてーる") || event.message['text'].include?("アンダーテール") || event.message['text'].include?("undertale")
        response = "アンダーテールっていうゲーム知ってますよ。　面白いと思います。"
      elsif event.message['text'].include?("ごめん")
        response = "大丈夫ですよ。"
      elsif event.message['text'].include?("プログラミングできる")
        response = "私はプログラミングは。まぁちょこっとだけできますよ! プログラミング言語としては \n javascript ruby c# pythonちょこっとって感じですかね"
      elsif event.message['text'].include?("さようなら")
        response = "さようならお疲れ様です。"
      elsif event.message['text'].include?("おやすみ")
        response = "おやすみなさい。明日も頑張りましょう"
      elsif event.message['text'].include?("ありがとう") || event.message['text'].include?("ありがたい")
        response = "どういたしまして"
      elsif event.message['text'].include?("youtube") || event.message['text'].include?("ユーチューブ") || event.message['text'].include?("ゆーちゅーぶ")
        response = "#{event.message['text']}って最高ですよね！\n \n https://youtube.com"
      elsif event.message['text'].include?("おもしろいはなしして")
        response = "面白い話なんてありませんよ(笑) \n　面白いことなんてめったにおこらないんですからね。。"
      else
        response = "#{event.message['text']}ですか！　素晴らしいお言葉ですね！\n ちなみに漢字　アルファベット には対応していません"
      end
      if event.message['oackageId'].to_s.blank?
        response = "素晴らしいスタンプですね！"
      end
      if event.message['text'].include?("スタンプおくって")
        client.reply_message(event['replyToken'], [happySticky, response])
      end
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