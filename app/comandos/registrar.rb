require_relative 'comando'
class ComandoRegistrar < Comando
  ENDPOINT = "#{ENV['API_URL']}/usuarios".freeze

  def initialize(nombre, email, telegram_id, telegram_username, presentador)
    @nombre = nombre
    @email = email
    @telegram_id = telegram_id
    @telegram_username = telegram_username
    @presentador = presentador
    super()
  end

  def ejecutar
    respuesta = Faraday.post(ENDPOINT, { nombre: @nombre, email: @email, telegram_id: @telegram_id, telegram_username: @telegram_username }.to_json)
    if respuesta.status == STATUS_CODE_SUCCESS_CREATING
      @presentador.bienbenido(@nombre)
    else
      manejar_error(respuesta)
    end
  end
end
