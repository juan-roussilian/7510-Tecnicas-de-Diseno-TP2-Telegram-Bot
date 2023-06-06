require 'spec_helper'
require 'dotenv/load'

class ApiMock
  def self.registrar_post_mock(nombre, email)
    body = { nombre:, email: }
    respuesta = { id: 1, nombre:, email: }

    WebMock.stub_request(:post, "#{ENV['API_URL']}/usuarios")
           .with(body: body.to_json, headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/x-www-form-urlencoded',
                                                'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 201, body: respuesta.to_json, headers: {})
  end

  def self.saldo_get_mock(usuario)
    respuesta = { ususario: usuario, saldo: 0 }
    WebMock.stub_request(:get, "#{ENV['API_URL']}/saldo?usuario=#{usuario}")
           .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 200, body: respuesta.to_json, headers: {})
  end
end
