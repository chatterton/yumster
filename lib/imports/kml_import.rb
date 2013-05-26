require "./lib/imports/location_builder"
require "./lib/imports/kml_reader"

builder = LocationBuilder.new ARGV[0], ARGV[1]
reader = KMLReader.new ARGV[0], builder
reader.read
builder.write
