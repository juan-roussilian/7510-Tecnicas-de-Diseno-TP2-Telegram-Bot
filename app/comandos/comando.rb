class Comando
  STATUS_ERROR_SERVIDOR = 500

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
