require "rexml/document"

class KMLReader
  include ActionView::Helpers::SanitizeHelper

  def initialize(filename, builder)
    puts "KMLReader on "+filename
    @filename = filename
    @builder = builder
  end

  def read
    file = File.new @filename
    doc = REXML::Document.new file
    doc.elements.each("kml/Document/Placemark") do |e|
      process_placemark e
    end
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
