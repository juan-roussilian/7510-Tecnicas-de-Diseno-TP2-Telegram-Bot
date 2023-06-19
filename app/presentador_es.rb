class PresentadorES
  GRUPO_CREADO = 'Grupo creado'.freeze
  GASTO_CREADO = 'Gasto creado id:'.freeze
  TRANSFERENCIA = 'Transferencia exitosa'.freeze
  SALDO = 'Saldo'.freeze
  BIENVENIDO = 'Bienvenido'.freeze
  def presentar_movimientos(movimientos)
    texto = movimientos.empty? ? 'No se registran movimientos' : ''

    movimientos.each do |movimiento|
      fecha = movimiento['fecha']
      monto = movimiento['monto']
      tipo = movimiento['tipo']
      case tipo
      when 'pago'
        texto << "#{fecha} , pago recibido de #{movimiento['usuario_secundario']}: #{monto}, gasto #{movimiento['id_gasto']}\n"
      when 'transferencia'
        texto << "#{fecha} , #{tipo} de #{monto} a #{movimiento['usuario_secundario']}\n"
      when 'carga'
        texto << "#{fecha} , #{tipo} saldo, #{monto}\n"
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

  def presentar_gasto_creado(id)
    "#{GASTO_CREADO} #{id}"
  end

  def grupo_creado
    GRUPO_CREADO
  end

  def transferencia_exitosa(monto, destinatario)
    "#{TRANSFERENCIA} de #{monto} a #{destinatario}"
  end

  def saldo(monto)
    "#{SALDO}: #{monto}"
  end

  def bienvenido(nombre)
    "#{BIENVENIDO}, #{nombre}"
  end

  def presentar_gasto_pagado(informacion_de_pago)
    gasto_id = informacion_de_pago['id_gasto']
    nombre_gasto = informacion_de_pago['nombre_gasto']
    cobrado = informacion_de_pago['cobro']
    nombre_grupo = informacion_de_pago['nombre_grupo']
    pendiente = informacion_de_pago['pendiente']
    "Gasto #{gasto_id}, #{nombre_gasto},\nCobrado: #{cobrado},\nGrupo: #{nombre_grupo},\nPendiente: #{pendiente}\n"
  end
end
