## Usage:
## be rails runner lib/imports/csv_import.rb file.csv "import name" "info credit line"
require "./lib/imports/location_importer"
require "./lib/imports/csv_reader"

importer = LocationImporter.new ARGV[1], ARGV[2]
reader = CSVReader.new ARGV[0], importer
reader.read
importer.write
