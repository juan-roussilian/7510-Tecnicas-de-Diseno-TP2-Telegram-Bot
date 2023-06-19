class ComandoPagarGasto < Comando
  ENDPOINT = "#{ENV['API_URL']}/pagos".freeze
  def initialize(usuario, id_gasto, monto, presentador)
    @presentador = presentador
    @usuario = usuario
    @id_gasto = id_gasto
    @monto = monto
    super()
  end

  def ejecutar
    respuesta = Faraday.post(ENDPOINT, { usuario: @usuario, id_gasto: @id_gasto, monto: @monto }.to_json)
    if respuesta.status == STATUS_CODE_SUCCESS_CREATING
      informacion_de_pago = JSON.parse(respuesta.body)
      @presentador.presentar_gasto_pagado(informacion_de_pago)
    else
      manejar_error(respuesta)
    end
  end
end
