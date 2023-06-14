require_relative 'comando'

class ComandoSaldo < Comando
  STATUS_CODE_OK = 200

  def initialize(usuario)
    @usuario = usuario
    super()
  end

  def ejecutar
    endpoint = "#{ENV['API_URL']}/saldo?usuario=#{@usuario}"
    respuesta = Faraday.get(endpoint)
    if respuesta.status == STATUS_CODE_OK
      saldo = JSON.parse(respuesta.body)['saldo']
      "Saldo: #{saldo}"
    else
      manejar_error(respuesta)
    end
  end
end
