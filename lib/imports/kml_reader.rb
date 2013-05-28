require "rexml/document"
require "open-uri"

class KMLReader
  include ActionView::Helpers::SanitizeHelper

  def initialize(file_or_uri, builder)
    print "KMLReader reading in #{file_or_uri} ... "
    @file_or_uri = file_or_uri
    @builder = builder
  end

  def read
    data = open @file_or_uri
    doc = REXML::Document.new data
    doc.elements.each("kml/Document/Placemark") do |e|
      process_placemark e
    end
    puts "done."
  end

  def process_placemark(placemark)
    location = {}
    location[:name] = placemark.elements["name"].text
    location[:notes] = strip_tags placemark.elements["description"].text
    coords = placemark.elements["Point"].elements["coordinates"].text.split ','
    location[:lat] = coords[1]
    location[:lng] = coords[0]
    @builder.add location
  end

end
