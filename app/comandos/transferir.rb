require_relative 'comando'

class ComandoTransferir < Comando
  ENDPOINT = "#{ENV['API_URL']}/transferir".freeze

  def initialize(usuario, monto, destinatario)
    @usuario = usuario
    @monto = monto
    @destinatario = destinatario
    super()
  end

  def ejecutar
    respuesta = Faraday.post(ENDPOINT, { usuario: @usuario, monto: @monto, destinatario: @destinatario }.to_json)
    if respuesta.status == STATUS_CODE_OK
      "Transferencia exitosa de #{@monto} a #{@destinatario}"
    else
      manejar_error(respuesta)
    end
  end
end
