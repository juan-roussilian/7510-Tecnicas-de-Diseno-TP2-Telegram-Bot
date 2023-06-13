class Version
  MAYOR = 0
  MINOR = 5
  PATCH = 4

  def self.current
    "#{MAYOR}.#{MINOR}.#{PATCH}"
  end
end
