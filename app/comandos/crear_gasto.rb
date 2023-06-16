require_relative 'comando'

class ComandoCrearGasto < Comando
  ENDPOINT = "#{ENV['API_URL']}/gasto".freeze

  def initialize(usuario, nombre_gasto, monto, nombre_grupo)
    @usuario = usuario
    @nombre_gasto = nombre_gasto
    @monto = monto
    @nombre_grupo = nombre_grupo
    super()
  end

  def ejecutar
    respuesta = Faraday.post(ENDPOINT, { usuario: @usuario, nombre_gasto: @nombre_gasto, monto: @monto, nombre_grupo: @nombre_grupo }.to_json)
    if respuesta.status == STATUS_CODE_SUCCESS_CREATING
      "Gasto creado id: #{JSON.parse(respuesta.body)['id']}"
    else
      manejar_error(respuesta)
    end
  end
end
