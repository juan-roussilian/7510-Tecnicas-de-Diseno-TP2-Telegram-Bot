require 'byebug'
class PresentadorES
  def presentar_movimientos(movimientos)
    texto = ''

    movimientos.each do |movimiento|
      fecha = movimiento['fecha']
      valor = movimiento['valor']
      tipo = movimiento['tipo']
      case tipo
      when 'pago'
        texto << "#{fecha} , pago recibido de #{movimiento['usuario_pago']}: #{valor}, gasto #{movimiento['id_gasto']}\n"
      when 'transferencia', 'carga saldo'
        texto << "#{fecha} , #{tipo}, #{valor}\n"
      end
    end
    texto
  end

  def presentar_gasto(gasto)
    gasto_id = gasto['id']
    gasto_nombre = gasto['nombre']
    gasto_tipo = gasto['tipo']
    gasto_saldo = gasto['saldo']
    gasto_grupo = gasto['grupo']
    gasto_estado = gasto['estado']
    gasto_usuarios = gasto['usuarios']
    texto = ''
    texto << "Gasto #{gasto_id}, #{gasto_nombre},\nTipo: #{gasto_tipo},\nMonto: #{gasto_saldo},\nGrupo: #{gasto_grupo}\n"
    texto << "Estado: #{gasto_estado}\n"
    gasto_usuarios.each do |usuario|
      texto << "#{usuario['nombre']}: #{usuario['estado']}\n"
    end
    texto
  end
end
