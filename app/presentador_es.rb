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
end
