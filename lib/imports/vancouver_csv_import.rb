require 'open-uri'
require 'csv'

class VancouverCSVImport

  def initialize(file_or_uri, name, credit_line)
    @file_or_uri = file_or_uri
    @name = name
    @credit_line = credit_line
  end

  def read
    print "Reading in #{@file_or_uri} ... "
    data = open(@file_or_uri).read
    trees = []
    CSV.parse(data, :headers => true) do |row|
      trees << row
    end
    puts "done."
    return trees
  end

  def geolocate_and_write(trees)
    print "Geolocating and writing models ... "
    import = Import.new(name: @name, credit_line: @credit_line, import_type: 'location')
    import.save
    for tree in trees
      record = Record.new(data_key: tree['id'])
      location = Location.new(
        description: tree['commonname'],
        category: 'Plant',
        notes: @credit_line)
      location.latin_name = tree['latinname']
      location.address = "#{tree['address']}, Vancouver, British Columbia"
      location.city = 'Vancouver'
      location.state = 'British Columbia'
      location.state_code = 'BC'
      location.country = 'Canada'
      location.country_code = 'CA'
      location.street = tree['address']
      location.approved = true
      if location.geocode
        location.save
        record.location = location
        record.save
        import.records << record
        ## Do not overload the geocoder
        sleep 0.1
      else
        puts "failed to geolocate id = #{tree['id']}"
      end
    end
  end

end

import = VancouverCSVImport.new(ARGV[0], ARGV[1], ARGV[2])
trees = import.read
import.geolocate_and_write trees
