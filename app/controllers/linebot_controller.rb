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

  def callback

    # Postモデルの中身をランダムで@postに格納する
    @post=Post.offset( rand(Post.count) ).first
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head :bad_request
    end

    events = client.parse_events_from(body)

    events.each { |event|

      # event.message['text']でLINEで送られてきた文書を取得
      if event.message['text'].include?("こんにちは")
        response = "どうもこんにちは私はくろrailsまんのbotでございます。"
      elsif event.message["text"].include?("いってきます")
        response = "いってらっしゃいませ。ごしゅじんさま"
      elsif event.message['text'].include?("おはよう")
        response = "おはようございます。今日から一日が始まりますよ。"
      elsif event.message['text'].include?("だれ")
        response = "私はくろrailsまんのbotです。"
      elsif event.message['text'].include?("おい")
        response = "どうかいたしましたか？"
      elsif event.message['text'].include?("あんだーてーる")
        response = "アンダーテールっていうゲーム知ってますよ。　面白いと思います。"
      elsif event.message['text'].include?("ごめん")
        response = "大丈夫ですよ。"
      elsif event.message['text'].include?("プログラミングできる")
        response = "私ですか？プログラミングは。まぁちょこっとだけできますよ"
      elsif event.message['text'].include?("さようなら")
        response = "さようならお疲れ様です。"
      elsif event.message['text'].include?("おやすみ")
        response = "おやすみなさい。明日も頑張りましょう"
      else
        response = @post.name
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