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
    body = { usuario:, monto: monto.to_f, destinatario: }
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
    body = { usuario:, nombre_gasto:, monto: monto.to_f, nombre_grupo:, tipo: 'equitativo' }
    respuesta = { id: 1 }
    WebMock.stub_request(:post, "#{ENV['API_URL']}/gasto")
           .with(body: body.to_json, headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/x-www-form-urlencoded',
                                                'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 201, body: respuesta.to_json, headers: {})
  end

  def self.consultar_movimientos_get_mock(usuario)
    movimiento_carga = { fecha: '2021-06-01 12:35', tipo: 'carga', monto: 100, usuario_secundario: nil, id_gasto: nil }
    movimiento_transferencia = { fecha: '2021-06-02 16:05', tipo: 'transferencia', monto: 50, usuario_secundario: 'carlos', id_gasto: nil }
    movimiento_pago = { fecha: '2021-06-05 19:55', tipo: 'pago', monto: 30, usuario_secundario: 'pepe', id_gasto: 1 }
    respuesta = [movimiento_carga, movimiento_transferencia, movimiento_pago]

    WebMock.stub_request(:get, "#{ENV['API_URL']}/movimientos?usuario=#{usuario}")
           .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 200, body: respuesta.to_json, headers: {})
  end

  def self.consultar_gasto_get_mock(usuario)
    gasto = {
      id: 1,
      nombre: 'GastoPrueba',
      tipo: 'equitativo',
      saldo: '100',
      grupo: 'grupoTest',
      creador: 'Haski',
      usuarios: [{ nombre: 'Juan', estado: 'Pendiente', cobro: 10.011 }]
    }
    WebMock.stub_request(:get, "#{ENV['API_URL']}/gasto?id_gasto=1&usuario=#{usuario}")
           .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 200, body: gasto.to_json, headers: {})
  end

  def self.pagar_gasto_post_mock(usuario)
    body = {
      usuario:,
      id_gasto: 1,
      monto: 100.0
    }
    respuesta = {
      id_gasto: 1,
      nombre_gasto: 'GastoPrueba',
      cobro: 100,
      nombre_grupo: 'grupoTest',
      pendiente: 0.0
    }
    WebMock.stub_request(:post, "#{ENV['API_URL']}/pagos")
           .with(body: body.to_json, headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent' => 'Faraday v2.7.4' })
           .to_return(status: 201, body: respuesta.to_json, headers: {})
  end
end
