require_relative 'comando'

class ComandoSaldo < Comando
  def initialize(usuario, presentador)
    @usuario = usuario
    @presentador = presentador
    super()
  end

  def ejecutar
    endpoint = "#{ENV['API_URL']}/saldo?usuario=#{@usuario}"
    respuesta = Faraday.get(endpoint)
    if respuesta.status == STATUS_CODE_OK
      saldo = JSON.parse(respuesta.body)['saldo']
      @presentador.saldo(saldo)
    else
      manejar_error(respuesta)
    end
  end
end
