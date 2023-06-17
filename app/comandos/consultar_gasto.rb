require_relative 'comando'

class ComandoConsultarGasto < Comando
  ENDPOINT = "#{ENV['API_URL']}/gasto".freeze
  def initialize(usuario, id_gasto, presentador)
    @usuario = usuario
    @id_gasto = id_gasto
    @presentador = presentador
    super()
  end

  def ejecutar
    argumentos = { usuario: @usuario, id_gasto: @id_gasto }
    respuesta = Faraday.get(ENDPOINT, argumentos)
    if respuesta.status == STATUS_CODE_OK
      info_gasto = JSON.parse(respuesta.body)
      @presentador.presentar_gasto(info_gasto)
    else
      manejar_error(respuesta)
    end
  end
end
