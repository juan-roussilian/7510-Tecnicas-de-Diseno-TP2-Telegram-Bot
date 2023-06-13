class ComandoCrearGasto
  def initialize(usuario, nombre_gasto, monto, nombre_grupo)
    @usuario = usuario
    @nombre_gasto = nombre_gasto
    @monto = monto
    @nombre_grupo = nombre_grupo
  end

  def ejecutar
    endpoint = "#{ENV['API_URL']}/gasto"
    respuesta = Faraday.post(endpoint, { usuario: @usuario, nombre_gasto: @nombre_gasto, monto: @monto, nombre_grupo: @nombre_grupo }.to_json)
    "Gasto creado id: #{JSON.parse(respuesta.body)['id']}"
  end
end
