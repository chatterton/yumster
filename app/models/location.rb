class Location < ActiveRecord::Base
  attr_accessible :description, :latitude, :longitude, :category
  attr_protected :address, :street, :city, :state, :state_code, :postal_code, :country, :country_code, :user_id, :neighborhood, :approved
  belongs_to :user
  has_many :tips
  has_many :users, :through => :tips

  ## for https://github.com/alexreisner/geocoder
  reverse_geocoded_by :latitude, :longitude do |loc, results|
    if geo = results.first
      if defined? geo.address_components_of_type
        number = geo.address_components_of_type(:street_number).first ? geo.address_components_of_type(:street_number).first['long_name'] : ""
        neighborhood = geo.address_components_of_type(:neighborhood).first ? geo.address_components_of_type(:neighborhood).first['long_name'] : ""
        route = geo.address_components_of_type(:route).first ? geo.address_components_of_type(:route).first['long_name'] : ""
        loc.street = "#{number} #{geo.route}"
        loc.address = "#{loc.street}, #{geo.city}, #{geo.state}"
        loc.neighborhood = neighborhood
      else
        loc.address = geo.address
      end
      loc.city = geo.city
      loc.state = geo.state
      loc.state_code = geo.state_code
      loc.postal_code = geo.postal_code
      loc.country = geo.country
      loc.country_code = geo.country_code
    end
  end

  validates :latitude, presence: true, :numericality => {
    :greater_than_or_equal_to => -90,
    :less_than_or_equal_to => 90
  }
  validates :longitude, presence: true, :numericality => {
    :greater_than_or_equal_to => -180,
    :less_than_or_equal_to => 180
  }

  validates :description, presence: true
  validates_length_of :description, :minimum => 5, :maximum => 45

  validates :category, presence: true
  CATEGORIES = %w( Plant Dumpster Organization )
  validates_inclusion_of :category, :in => CATEGORIES

  NEARBY_DISTANCE_MI = 0.75
  MAX_LOCATIONS = 1000
  MILES_IN_A_DEGREE = 69.1

  def self.deg_to_mi(degrees)
    MILES_IN_A_DEGREE * degrees
  end

  def self.find_near(latitude, longitude, box_width)
    radius_miles = self.deg_to_mi(box_width.to_f / 2)
    box = Geocoder::Calculations.bounding_box([latitude, longitude], radius_miles)
    location_size = Location.within_bounding_box(box).count
    if (location_size > Location::MAX_LOCATIONS)
      raise "Too many locations returned"
    end
    locations = Location.within_bounding_box(box)
    return locations
  end

end
