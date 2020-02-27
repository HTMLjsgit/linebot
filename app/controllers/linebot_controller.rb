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
      if event.message['text'].include?("好き")
        response = "んほぉぉぉぉぉぉ！すきすきすきすきすきすきすきすきぃぃぃぃぃ"
      elsif event.message["text"].include?("行ってきます")
        response = "どこいくの？どこいくの？どこいくの？寂しい寂しい寂しい。。。"
      elsif event.message['text'].include?("おはよう")
        response = "おはよう。なんで今まで連絡くれなかったの？"
      elsif event.message['text'].include?("みーくん")
        response = "みーくん！？" * 50
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