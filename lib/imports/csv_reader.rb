require 'open-uri'
require 'csv'

class CSVReader

  def initialize(file_or_uri, builder)
    @file_or_uri = file_or_uri
    @builder = builder
  end

  def read
    print "KMLReader reading in #{@file_or_uri} ... "
    data = open @file_or_uri
    CSV.parse(data, :headers => true) do |row|
      @builder.add create_hash(row)
    end
    puts "done."
  end

  def create_hash(row)
    hash = {}
    hash[:latitude] = row['longitude']
    hash[:longitude] = row['longitude']
    hash[:description] = row['description']
    hash[:data_key] = row['data_key']
    hash[:notes] = row['notes']
    hash[:latin_name] = row['latin_name']
    hash[:address] = row['address']
    hash[:city] = row['city']
    hash[:state] = row['state']
    hash[:state_code] = row['state_code']
    hash[:country] = row['country']
    hash[:country_code] = row['country_code']
    hash
  end

end
