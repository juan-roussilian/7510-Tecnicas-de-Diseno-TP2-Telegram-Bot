require 'spec_helper'
require 'web_mock'
require 'api_mock'
# Uncomment to use VCR
# require 'vcr_helper'

require "#{File.dirname(__FILE__)}/../app/bot_client"

def when_i_send_text(token, message_text)
  body = { "ok": true, "result": [{ "update_id": 693_981_718,
                                    "message": { "message_id": 11,
                                                 "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                                                 "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                                                 "date": 1_557_782_998, "text": message_text,
                                                 "entities": [{ "offset": 0, "length": 6, "type": 'bot_command' }] } }] }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def when_i_send_keyboard_updates(token, message_text, inline_selection)
  body = {
    "ok": true, "result": [{
      "update_id": 866_033_907,
      "callback_query": { "id": '608740940475689651', "from": { "id": 141_733_544, "is_bot": false, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "language_code": 'en' },
                          "message": {
                            "message_id": 626,
                            "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                            "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                            "date": 1_595_282_006,
                            "text": message_text,
                            "reply_markup": {
                              "inline_keyboard": [
                                [{ "text": 'Jon Snow', "callback_data": '1' }],
                                [{ "text": 'Daenerys Targaryen', "callback_data": '2' }],
                                [{ "text": 'Ned Stark', "callback_data": '3' }]
                              ]
                            }
                          },
                          "chat_instance": '2671782303129352872',
                          "data": inline_selection }
    }]
  }

  stub_request(:any, "https://api.telegram.org/bot#{token}/getUpdates")
    .to_return(body: body.to_json, status: 200, headers: { 'Content-Length' => 3 })
end

def then_i_get_text(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544', 'text' => message_text }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

def then_i_get_keyboard_message(token, message_text)
  body = { "ok": true,
           "result": { "message_id": 12,
                       "from": { "id": 715_612_264, "is_bot": true, "first_name": 'fiuba-memo2-prueba', "username": 'fiuba_memo2_bot' },
                       "chat": { "id": 141_733_544, "first_name": 'Emilio', "last_name": 'Gutter', "username": 'egutter', "type": 'private' },
                       "date": 1_557_782_999, "text": message_text } }

  stub_request(:post, "https://api.telegram.org/bot#{token}/sendMessage")
    .with(
      body: { 'chat_id' => '141733544',
              'reply_markup' => '{"inline_keyboard":[[{"text":"Jon Snow","callback_data":"1"},{"text":"Daenerys Targaryen","callback_data":"2"},{"text":"Ned Stark","callback_data":"3"}]]}',
              'text' => 'Quien se queda con el trono?' }
    )
    .to_return(status: 200, body: body.to_json, headers: {})
end

describe 'BotClient' do
  it 'should get a /version message and respond with current version' do
    token = 'fake_token'

    when_i_send_text(token, '/version')
    then_i_get_text(token, Version.current)

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /say_hi message and respond with Hola Emilio' do
    token = 'fake_token'

    when_i_send_text(token, '/say_hi Emilio')
    then_i_get_text(token, 'Hola, Emilio')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /start message and respond with Hola' do
    token = 'fake_token'

    when_i_send_text(token, '/start')
    then_i_get_text(token, 'Hola, Emilio')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /stop message and respond with Chau' do
    token = 'fake_token'

    when_i_send_text(token, '/stop')
    then_i_get_text(token, 'Chau, egutter')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a /tv message and respond with an inline keyboard' do
    token = 'fake_token'

    when_i_send_text(token, '/tv')
    then_i_get_keyboard_message(token, 'Quien se queda con el trono?')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a "Quien se queda con el trono?" message and respond with' do
    token = 'fake_token'

    when_i_send_keyboard_updates(token, 'Quien se queda con el trono?', '2')
    then_i_get_text(token, 'A mi también me encantan los dragones!')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get an unknown message message and respond with Do not understand' do
    token = 'fake_token'

    when_i_send_text(token, '/unknown')
    then_i_get_text(token, 'Uh? No te entiendo! Me repetis la pregunta?')

    app = BotClient.new(token)

    app.run_once
  end

  it 'should get a "/registrar name, email" message with valid email and respond with "Bienvenido, name"' do
    ApiMock.registrar_post_mock('Pedro', 'pedro@test.com', 141_733_544, 'egutter')
    when_i_send_text('fake_token', '/registrar Pedro, pedro@test.com')
    then_i_get_text('fake_token', 'Bienvenido, Pedro')

    app = BotClient.new('fake_token')
    app.run_once
  end

  it 'should get a "/saldo" message from user with balance 0 and respond with the users current balance' do
    ApiMock.saldo_get_mock(141_733_544)
    when_i_send_text('fake_token', '/saldo')
    then_i_get_text('fake_token', 'Saldo: 0')

    app = BotClient.new('fake_token')
    app.run_once
  end

  it 'should get a "/transferir 500 @Juan" message from user with balance 500 and respond with "Transferencia exitosa de 500.0 a @Juan"' do
    ApiMock.transferir_post_mock(141_733_544, 500, '@Juan')
    when_i_send_text('fake_token', '/transferir 500, @Juan')
    then_i_get_text('fake_token', 'Transferencia exitosa de 500.0 a @Juan')

    app = BotClient.new('fake_token')
    app.run_once
  end

  it 'should get a "/crear-grupo GrupoTest Juan" message from user and respond with "Grupo creado"' do
    ApiMock.crear_grupo_post_mock('GrupoTest', %w[Juan egutter])
    when_i_send_text('fake_token', '/crear-grupo GrupoTest Juan')
    then_i_get_text('fake_token', 'Grupo creado')

    app = BotClient.new('fake_token')
    app.run_once
  end

  it 'should get a "/crear-gasto pizza 2000 GrupoPizzas" message from user and respond with "Gasto creado"' do
    ApiMock.crear_gasto_post_mock(141_733_544, 'pizza', 2000, 'GrupoPizzas')
    when_i_send_text('fake_token', '/crear-gasto pizza 2000 GrupoPizzas')
    then_i_get_text('fake_token', 'Gasto creado id: 1')

    app = BotClient.new('fake_token')
    app.run_once
  end

  it 'should get a "/crear-gasto pizza 2000 GrupoPizzas gorra" message from user and respond with "Gasto creado"' do
    ApiMock.crear_gasto_gorra_post_mock(141_733_544, 'pizza', 2000, 'GrupoPizzas')
    when_i_send_text('fake_token', '/crear-gasto pizza 2000 GrupoPizzas gorra')
    then_i_get_text('fake_token', 'Gasto creado id: 1')

    app = BotClient.new('fake_token')
    app.run_once
  end

  it 'shoud get a "/consultar-movimientos" message from user and repond with user movements' do
    ApiMock.consultar_movimientos_get_mock(141_733_544)
    when_i_send_text('fake_token', '/consultar-movimientos')
    movements_string = "2021-06-01 12:35 , carga saldo, 100\n2021-06-02 16:05 , transferencia de 50 a carlos\n2021-06-05 19:55 , pago recibido de pepe: 30, gasto 1\n"
    then_i_get_text('fake_token', movements_string)
    BotClient.new('fake_token').run_once
  end

  it 'shoud get a "/consultar-gasto" message from user and repond with its information' do
    ApiMock.consultar_gasto_get_mock(141_733_544)
    when_i_send_text('fake_token', '/consultar-gasto 1')

    gasto_string = "Gasto 1: GastoPrueba\nTipo: equitativo\nMonto: 100\nGrupo: grupoTest\nJuan -> Haski: Pendiente\n"

    then_i_get_text('fake_token', gasto_string)
    BotClient.new('fake_token').run_once
  end

  it 'shoud get a "/pagar-gasto" message with amount from user and repond with the payment information' do
    ApiMock.pagar_gasto_post_mock(141_733_544, 100)
    when_i_send_text('fake_token', '/pagar-gasto 1 100')

    gasto_string = "Gasto 1, GastoPrueba,\nCobrado: 100,\nGrupo: grupoTest,\nPendiente: 0.0\n"

    then_i_get_text('fake_token', gasto_string)
    BotClient.new('fake_token').run_once
  end

  it 'shoud get a "/pagar-gasto" message without amount from user and repond with the payment information' do
    ApiMock.pagar_gasto_post_mock(141_733_544, nil)
    when_i_send_text('fake_token', '/pagar-gasto 1')

    gasto_string = "Gasto 1, GastoPrueba,\nCobrado: 100,\nGrupo: grupoTest,\nPendiente: 0.0\n"

    then_i_get_text('fake_token', gasto_string)
    BotClient.new('fake_token').run_once
  end
end
