require_relative 'comando'
require 'byebug'
class ComandoRegistrar < Comando
  STATUS_CODE_SUCCESS_CREATING = 201
  ENDPOINT = "#{ENV['API_URL']}/usuarios".freeze

  def initialize(nombre, email, telegram_id, telegram_username)
    @nombre = nombre
    @email = email
    @telegram_id = telegram_id
    @telegram_username = telegram_username
    super()
  end

  def ejecutar
    respuesta = Faraday.post(ENDPOINT, { nombre: @nombre, email: @email, telegram_id: @telegram_id, telegram_username: @telegram_username }.to_json)
    if respuesta.status == STATUS_CODE_SUCCESS_CREATING
      "Bienvenido, #{@nombre}"
    else
      manejar_error(respuesta)
    end
  end
end
