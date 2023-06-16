require_relative 'comando'

class ComandoConsultarMovimientos < Comando
  def initialize(usuario, presentador)
    @presentador = presentador
    @usuario = usuario
    super()
  end

  def ejecutar
    endpoint = "#{ENV['API_URL']}/movimientos?usuario=#{@usuario}"
    respuesta = Faraday.get(endpoint)
    if respuesta.status == STATUS_CODE_OK
      movimientos = JSON.parse(respuesta.body)
      @presentador.presentar_movimientos(movimientos)
    else
      manejar_error(respuesta)
    end
  end
end
