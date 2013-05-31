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
        latitude: hash[:latitude].to_f,
        longitude: hash[:longitude].to_f,
        category: 'Plant',
        notes: "#{hash[:notes]}")
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
        puts "LocationImporter dk=#{hash[:data_key]} error: #{location.errors.to_json}"
        puts location.to_json
        next
      end

      location.save
      record.location = location
      record.save
      import.records << record
    end
    puts "done."
  end

end
