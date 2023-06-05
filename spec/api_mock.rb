require 'spec_helper'
require 'dotenv/load'

class ApiMock
  def self.post_mock(nombre, email)
    body = { nombre:, email: }
    respuesta = { id: 1, nombre:, email: }

    WebMock.stub_request(:post, "#{ENV['API_URL']}/usuarios")
           .with(body: body.to_json, headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/x-www-form-urlencoded',
                                                'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 201, body: respuesta.to_json, headers: {})
  end
end
