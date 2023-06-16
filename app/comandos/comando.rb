class Comando
  STATUS_ERROR_SERVIDOR = 500
  STATUS_CODE_SUCCESS_CREATING = 201
  STATUS_CODE_OK = 200

  # TODO: Refactorizar para que la clase Invoker utilice los comandos y un presentador de
  # que imprime por consola en espanol

  def manejar_error(respuesta)
    if respuesta.status == STATUS_ERROR_SERVIDOR
      'Error del servidor'
    elsif JSON.parse(respuesta.body).key?('error')
      "Error: #{JSON.parse(respuesta.body)['error']}"
    else
      'Error desconocido'
    end
  end
end
