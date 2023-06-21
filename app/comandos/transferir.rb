require_relative 'comando'

class ComandoTransferir < Comando
  def initialize(usuario, monto, destinatario, presentador)
    @usuario = usuario
    @monto = monto
    @destinatario = destinatario
    @presentador = presentador
    super()
  end

  def ejecutar
    body = { usuario: @usuario, monto: @monto, destinatario: @destinatario }.to_json
    respuesta = ApiGastos.new.transferir(body)
    if respuesta.status == STATUS_CODE_OK
      @presentador.transferencia_exitosa(@monto, @destinatario)
    else
      manejar_error(respuesta)
    end
  end
end
