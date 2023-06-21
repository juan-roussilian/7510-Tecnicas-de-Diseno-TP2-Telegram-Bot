require "#{File.dirname(__FILE__)}/../api_gastos"

class Comando
  STATUS_ERROR_SERVIDOR = 500
  STATUS_CODE_SUCCESS_CREATING = 201
  STATUS_CODE_OK = 200

  def manejar_error(respuesta)
    if respuesta.status == STATUS_ERROR_SERVIDOR
      @presentador.error_servidor
    elsif JSON.parse(respuesta.body).key?('error')
      @presentador.error(JSON.parse(respuesta.body)['error'])
    else
      @presentador.error_desconocido(respuesta.status)
    end
  end
end
