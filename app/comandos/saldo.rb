require_relative 'comando'

class ComandoSaldo < Comando
  def initialize(usuario, presentador)
    @usuario = usuario
    @presentador = presentador
    super()
  end

  def ejecutar
    argumentos = { usuario: @usuario }
    respuesta = ApiGastos.new.consultar_saldo(argumentos)
    if respuesta.status == STATUS_CODE_OK
      saldo = JSON.parse(respuesta.body)['saldo']
      @presentador.saldo(saldo)
    else
      manejar_error(respuesta)
    end
  end
end
