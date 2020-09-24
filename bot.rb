require 'telegram/bot'

token = ENV['TOKEN']
user_list = ENV['WL'].split(',')

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    begin
      if user_list.include?(message.chat.id.to_s)
        case message.text
        when /youtu/
          %x(/app/youtube-dl.dms -x --audio-format mp3 --audio-quality 8 --output "/tmp/audio.%(ext)s" #{message.text})
          bot.api.send_audio(chat_id: message.chat.id, audio: Faraday::UploadIO.new('/tmp/audio.mp3', 'audio/mp3'))
        when //
          bot.api.send_message(chat_id: message.chat.id, text: message.text)
        end
      end
    rescue
      bot.api.send_message(chat_id: message.chat.id, text: "Error")
    end
  end
end