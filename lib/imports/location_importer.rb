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

  def write(options = {})
    print "LocationImporter writing models ... "
    import = Import.new(name: @name, credit_line: @credit_line, import_type: 'location')
    import.save
    for hash in @records
      record = Record.new(data_key: hash[:data_key])

      ## Necessary on all imports
      location = Location.new(
        description: hash[:description],
        latitude: hash[:lat].to_f,
        longitude: hash[:lng].to_f,
        category: 'Plant',
        notes: "#{hash[:notes]} #{@credit_line}")
      location.approved = true

      ## Bring in geocoded values
      location.latin_name = hash[:latin_name]
      location.address = hash[:address]
      location.city = hash[:city]
      location.state = hash[:state]
      location.state_code = hash[:state_code]
      location.country = hash[:country]
      location.country_code = hash[:country_code]

      ## Do not geocode if we already have geocoded values
      if options[:reverse_geocode]
        location.reverse_geocode
      end

      unless location.valid?
        puts location.errors.to_json
      end

      location.save
      record.location = location
      record.save
      import.records << record
    end
    puts "done."
  end

end
