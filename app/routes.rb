require "#{File.dirname(__FILE__)}/../lib/routing"
require "#{File.dirname(__FILE__)}/../lib/version"
require "#{File.dirname(__FILE__)}/tv/series"
require "#{File.dirname(__FILE__)}/comandos/crear_gasto"
require "#{File.dirname(__FILE__)}/comandos/crear_grupo"
require "#{File.dirname(__FILE__)}/comandos/transferir"
require "#{File.dirname(__FILE__)}/comandos/saldo"
require "#{File.dirname(__FILE__)}/comandos/registrar"
require "#{File.dirname(__FILE__)}/comandos/consultar_movimientos"
require "#{File.dirname(__FILE__)}/comandos/consultar_gasto"
require "#{File.dirname(__FILE__)}/presentador_es"
require 'dotenv/load'

class Routes
  include Routing
  STATUS_CODE_OK = 200
  STATUS_CODE_SUCCESS_CREATING = 201

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
    salida = ComandoRegistrar.new(args['nombre'], args['email'], message.from.id, message.from.username, PresentadorES.new).ejecutar
    bot.api.send_message(chat_id: message.chat.id, text: salida)
  end

  on_message '/saldo' do |bot, message|
    salida = ComandoSaldo.new(message.from.id, PresentadorES.new).ejecutar
    bot.api.send_message(chat_id: message.chat.id, text: salida)
  end

  on_message '/consultar-movimientos' do |bot, message|
    salida = ComandoConsultarMovimientos.new(message.from.id, PresentadorES.new).ejecutar
    bot.api.send_message(chat_id: message.chat.id, text: salida)
  end

  on_message_pattern %r{/transferir (?<monto>.*), (?<destinatario>.*)} do |bot, message, args|
    salida = ComandoTransferir.new(message.from.id, args['monto'].to_i, args['destinatario'], PresentadorES.new).ejecutar
    bot.api.send_message(chat_id: message.chat.id, text: salida)
  end

  on_message_pattern %r{/crear-grupo (?<nombre_grupo>.*) (?<usuarios>.*)} do |bot, message, args|
    usuarios = args['usuarios'].split(',')
    salida = ComandoCrearGrupo.new(message.from.username, args['nombre_grupo'], usuarios, PresentadorES.new).ejecutar
    bot.api.send_message(chat_id: message.chat.id, text: salida)
  end

  on_message_pattern %r{/crear-gasto (?<nombre_gasto>.*) (?<monto>.*) (?<nombre_grupo>.*)} do |bot, message, args|
    salida = ComandoCrearGasto.new(message.from.id, args['nombre_gasto'], args['monto'].to_i, args['nombre_grupo'], PresentadorES.new).ejecutar
    bot.api.send_message(chat_id: message.chat.id, text: salida)
  end

  on_message_pattern %r{/consultar-gasto (?<id_gasto>.*)} do |bot, message, args|
    salida = ComandoConsultarGasto.new(message.from.id, args['id_gasto'], PresentadorES.new).ejecutar
    bot.api.send_message(chat_id: message.chat.id, text: salida)
  end

  default do |bot, message|
    bot.api.send_message(chat_id: message.chat.id, text: 'Uh? No te entiendo! Me repetis la pregunta?')
  end
end
