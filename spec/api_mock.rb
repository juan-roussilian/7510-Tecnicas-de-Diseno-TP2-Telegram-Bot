require 'spec_helper'
require 'dotenv/load'

class ApiMock
  def self.registrar_post_mock(nombre, email, telegram_id, telegram_username)
    body = { nombre:, email:, telegram_id:, telegram_username: }
    respuesta = { id: 1, nombre:, email:, telegram_id: }
    WebMock.stub_request(:post, "#{ENV['API_URL']}/usuarios")
           .with(body: body.to_json, headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/x-www-form-urlencoded',
                                                'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 201, body: respuesta.to_json, headers: {})
  end

  def self.saldo_get_mock(usuario)
    respuesta = { usuario:, saldo: 0 }
    WebMock.stub_request(:get, "#{ENV['API_URL']}/saldo?usuario=#{usuario}")
           .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 200, body: respuesta.to_json, headers: {})
  end

  def self.transferir_post_mock(usuario, monto, destinatario)
    body = { usuario:, monto:, destinatario: }
    WebMock.stub_request(:post, "#{ENV['API_URL']}/transferir")
           .with(body: body.to_json, headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/x-www-form-urlencoded',
                                                'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 200, body: '', headers: {})
  end

  def self.crear_grupo_post_mock(nombre_grupo, usuarios)
    body = { nombre_grupo:, usuarios: }
    WebMock.stub_request(:post, "#{ENV['API_URL']}/grupo")
           .with(body: body.to_json, headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/x-www-form-urlencoded',
                                                'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 201, body: '', headers: {})
  end

  def self.crear_gasto_post_mock(usuario, nombre_gasto, monto, nombre_grupo)
    body = { usuario:, nombre_gasto:, monto:, nombre_grupo: }
    respuesta = { id: 1 }
    WebMock.stub_request(:post, "#{ENV['API_URL']}/gasto")
           .with(body: body.to_json, headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/x-www-form-urlencoded',
                                                'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 201, body: respuesta.to_json, headers: {})
  end
end
