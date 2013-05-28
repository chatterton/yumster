## Usage:
## be rails runner lib/imports/kml_import.rb file.kml "import name" "info credit line"
require "./lib/imports/location_importer"
require "./lib/imports/kml_reader"

importer = LocationImporter.new ARGV[1], ARGV[2]
reader = KMLReader.new ARGV[0], importer
reader.read
importer.write
