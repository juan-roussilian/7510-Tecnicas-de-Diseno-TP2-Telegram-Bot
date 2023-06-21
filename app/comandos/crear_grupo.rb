require_relative 'comando'

class ComandoCrearGrupo < Comando
  def initialize(nombre_creador, nombre_grupo, lista_usuarios, presentador)
    @nombre_grupo = nombre_grupo
    lista_usuarios << nombre_creador
    @lista_usuarios = lista_usuarios
    @presentador = presentador
    super()
  end

  def ejecutar
    body = { nombre_grupo: @nombre_grupo, usuarios: @lista_usuarios }.to_json
    respuesta = ApiGastos.new.crear_grupo(body)
    if respuesta.status == STATUS_CODE_SUCCESS_CREATING
      @presentador.grupo_creado
    else
      manejar_error(respuesta)
    end
  end
end
