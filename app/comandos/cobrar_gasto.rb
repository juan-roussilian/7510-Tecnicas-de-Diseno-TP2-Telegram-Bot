class ComandoCobrarGasto < Comando
  ENDPOINT = "#{ENV['API_URL']}/cobrar-gasto".freeze
  def initialize(usuario, id_gasto, monto, presentador)
    @presentador = presentador
    @usuario = usuario
    @id_gasto = id_gasto
    @monto = monto
    super()
  end

  def ejecutar
    argumentos = { usuario: @usuario, id_gasto: @id_gasto, monto: @monto }
    respuesta = Faraday.get(ENDPOINT, argumentos)
    if respuesta.status == STATUS_CODE_OK
      info_cobranza = JSON.parse(respuesta.body)
      @presentador.presentar_gasto_cobrado(info_cobranza)
    else
      manejar_error(respuesta)
    end
  end
end
