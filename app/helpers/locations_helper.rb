module LocationsHelper

  def base_g4r_opts
    {
      map_options: {
        "processing" => "json",
        "auto_adjust" => true,
        "auto_zoom" => false,
        "zoom" => 18
      }
    }
  end

  def gmaps4rails_location(location)
    map_json = location.to_gmaps4rails
    g4r_opts = base_g4r_opts
    g4r_opts[:markers] = { "data" => map_json }
    g4r_opts
  end

  def gmaps4rails_detect
    g4r_opts = base_g4r_opts
    g4r_opts[:map_options][:detect_location] = true
    g4r_opts[:map_options][:center_on_user] = true
    g4r_opts
  end

  def gmaps4rails_detect_wide
    g4r_opts = gmaps4rails_detect
    g4r_opts[:map_options][:zoom] = 15
    g4r_opts
  end

  def gmaps4rails_zoomto_wide(lat, long)
    g4r_opts = base_g4r_opts
    g4r_opts[:map_options][:zoom] = 15
    g4r_opts[:map_options][:center_latitude] = lat
    g4r_opts[:map_options][:center_longitude] = long
    g4r_opts
  end

  NEARBY_DISTANCE_MI = 0.75

end
