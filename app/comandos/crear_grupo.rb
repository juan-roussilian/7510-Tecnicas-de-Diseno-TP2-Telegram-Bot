require_relative 'comando'

class ComandoCrearGrupo < Comando
  ENDPOINT = "#{ENV['API_URL']}/grupo".freeze

  def initialize(nombre_creador, nombre_grupo, lista_usuarios, presentador)
    @nombre_grupo = nombre_grupo
    lista_usuarios << nombre_creador
    @lista_usuarios = lista_usuarios
    @presentador = presentador
    super()
  end

  def ejecutar
    respuesta = Faraday.post(ENDPOINT, { nombre_grupo: @nombre_grupo, usuarios: @lista_usuarios }.to_json)
    if respuesta.status == STATUS_CODE_SUCCESS_CREATING
      @presentador.grupo_creado
    else
      manejar_error(respuesta)
    end
  end
end
