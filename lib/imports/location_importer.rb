class LocationImporter
  def initialize(name, credit_line)
    @name = name
    @credit_line = credit_line
    @import_type = 'location'
    @records = []
  end

  def add(location)
    @records << location
  end

  def write
    print "LocationImporter writing models ... "
    import = Import.new(name: @name, credit_line: @credit_line, import_type: 'location')
    import.save
    for hash in @records
      record = Record.new(data_key: hash[:data_key])
      location = Location.new(
        description: hash[:name],
        latitude: hash[:lat],
        longitude: hash[:lng],
        category: 'Plant',
        notes: hash[:notes] + @credit_line)
      location.approved = true
      location.save
      record.location = location
      record.save
      import.records << record
    end
    puts "done."
  end

end
