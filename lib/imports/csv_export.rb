## Usage: rails runner csv_export.rb import_id
require 'csv'

class CSVExport
  def export(import_id)
    csv_string = CSV.generate do |csv|
      csv << ['id','original_id','latitude','longitude','latin_name','description','address','city','state','state_code','country','country_code']
      import = Import.find ARGV[0]
      import.records.each do |record|
        location = record.location
        csv << [location.id, record.data_key, location.latitude, location.longitude, location.latin_name, location.description, location.address, location.city, location.state, location.state_code, location.country, location.country_code]
      end
    end
    return csv_string
  end
end

exporter = CSVExport.new
csv = exporter.export ARGV[0]
print csv
