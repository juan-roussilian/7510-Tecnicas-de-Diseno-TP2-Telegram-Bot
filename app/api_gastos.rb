class ApiGastos
  # Encapsula el uso de Faraday para los requests a la API de cada comando

  BASE_URL = ENV['API_URL'].freeze

  def consultar_movimientos(argumentos)
    Faraday.get("#{BASE_URL}/movimientos", argumentos)
  end

  def crear_gasto(body)
    Faraday.post("#{BASE_URL}/gasto", body)
  end

  def consultar_gasto(argumentos)
    Faraday.get("#{BASE_URL}/gasto", argumentos)
  end

  def crear_grupo(body)
    Faraday.post("#{BASE_URL}/grupo", body)
  end

  def pagar_gasto(body)
    Faraday.post("#{BASE_URL}/pagos", body)
  end

  def registrar(body)
    Faraday.post("#{BASE_URL}/usuarios", body)
  end

  def consultar_saldo(argumentos)
    Faraday.get("#{BASE_URL}/saldo", argumentos)
  end

  def transferir(body)
    Faraday.post("#{BASE_URL}/transferir", body)
  end
end
