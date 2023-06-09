require "#{File.dirname(__FILE__)}/../lib/routing"
require "#{File.dirname(__FILE__)}/../lib/version"
require "#{File.dirname(__FILE__)}/tv/series"
require 'dotenv/load'

class Routes
  include Routing
  STATUS_CODE_OK = 200

  on_message '/start' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola, #{message.from.first_name}")
  end

  on_message_pattern %r{/say_hi (?<name>.*)} do |bot, message, args|
    bot.api.send_message(chat_id: message.chat.id, text: "Hola, #{args['name']}")
  end

  on_message '/stop' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "Chau, #{message.from.username}")
  end

  on_message '/time' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: "La hora es, #{Time.now}")
  end

  on_message '/tv' do |bot, message|
    kb = [Tv::Series.all.map do |tv_serie|
      Telegram::Bot::Types::InlineKeyboardButton.new(text: tv_serie.name, callback_data: tv_serie.id.to_s)
    end]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)

    bot.api.send_message(chat_id: message.chat.id, text: 'Quien se queda con el trono?', reply_markup: markup)
  end

  on_message '/busqueda_centro' do |bot, message|
    kb = [
      Telegram::Bot::Types::KeyboardButton.new(text: 'Compartime tu ubicacion', request_location: true)
    ]
    markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
    bot.api.send_message(chat_id: message.chat.id, text: 'Busqueda por ubicacion', reply_markup: markup)
  end

  on_location_response do |bot, message|
    response = "Ubicacion es Lat:#{message.location.latitude} - Long:#{message.location.longitude}"
    bot.api.send_message(chat_id: message.chat.id, text: response)
  end

  on_response_to 'Quien se queda con el trono?' do |bot, message|
    response = Tv::Series.handle_response message.data
    bot.api.send_message(chat_id: message.message.chat.id, text: response)
  end

  on_message '/version' do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: Version.current)
  end

  on_message_pattern %r{/registrar (?<nombre>.*), (?<email>.*)} do |bot, message, args|
    endpoint = "#{ENV['API_URL']}/usuarios"
    Faraday.post(endpoint, { nombre: args['nombre'], email: args['email'], telegram_id: message.from.id, telegram_username: message.from.username }.to_json)
    bot.api.send_message(chat_id: message.chat.id, text: "Bienvenido, #{args['nombre']}")
  end

  on_message '/saldo' do |bot, message|
    endpoint = "#{ENV['API_URL']}/saldo?usuario=#{message.from.id}"
    respuesta = JSON.parse(Faraday.get(endpoint).body)
    bot.api.send_message(chat_id: message.chat.id, text: "Saldo: #{respuesta['saldo']}")
  end

  on_message_pattern %r{/transferir (?<monto>.*), (?<destinatario>.*)} do |bot, message, args|
    endpoint = "#{ENV['API_URL']}/transferir"
    respuesta = Faraday.post(endpoint, { usuario: message.from.id, monto: args['monto'].to_i, destinatario: args['destinatario'] }.to_json)
    if respuesta.status == STATUS_CODE_OK
      bot.api.send_message(chat_id: message.chat.id, text: "Transferencia exitosa de #{args['monto']} a #{args['destinatario']}")
    else
      bot.api.send_message(chat_id: message.chat.id, text: 'No se pudo realizar la transferencia.')
    end
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end
end
