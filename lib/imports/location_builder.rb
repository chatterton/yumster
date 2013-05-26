class LocationBuilder
  def initialize(name, credit_line)
    @name = name
    @credit_line = credit_line
    @import_type = 'location'
    @records = []
  end

  def add(location)
    @records << location
    #puts location
  end

  def write
    puts "LocationBuilder writing models"
  end

end
