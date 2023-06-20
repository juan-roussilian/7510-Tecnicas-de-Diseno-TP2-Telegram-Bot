require_relative 'comando'

class ComandoCrearGastoGorra < Comando
  ENDPOINT = "#{ENV['API_URL']}/gasto".freeze
  TIPO = 'gorra'.freeze

  def initialize(usuario, nombre_gasto, monto, nombre_grupo, presentador)
    @usuario = usuario
    @nombre_gasto = nombre_gasto
    @monto = monto
    @nombre_grupo = nombre_grupo
    @presentador = presentador
    super()
  end

  def ejecutar
    respuesta = Faraday.post(ENDPOINT, { usuario: @usuario, nombre_gasto: @nombre_gasto, monto: @monto, nombre_grupo: @nombre_grupo, tipo: TIPO }.to_json)
    if respuesta.status == STATUS_CODE_SUCCESS_CREATING
      @presentador.presentar_gasto_creado(JSON.parse(respuesta.body)['id'])
    else
      manejar_error(respuesta)
    end
  end
end
