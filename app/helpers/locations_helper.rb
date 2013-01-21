module LocationsHelper

  def gmaps4rails_opts(location)
    map_json = location.to_gmaps4rails
    {
      markers: { "data" => map_json },
      map_options: {
        "processing" => "json",
        "auto_adjust" => true,
        "auto_zoom" => false,
        "zoom" => 18
      }
    }
  end

end
