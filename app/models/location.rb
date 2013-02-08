class Location < ActiveRecord::Base
  attr_accessible :description, :latitude, :longitude, :category, :user_id

  ## Do not run geocoding on every validation
  acts_as_gmappable :process_geocoding => false

  ## for https://github.com/alexreisner/geocoder
  reverse_geocoded_by :latitude, :longitude

  validates :latitude, presence: true, :numericality => {
    :greater_than_or_equal_to => -90,
    :less_than_or_equal_to => 90
  }
  validates :longitude, presence: true, :numericality => {
    :greater_than_or_equal_to => -180,
    :less_than_or_equal_to => 180
  }

  validates :description, presence: true

  validates :category, presence: true
  CATEGORIES = %w( Plant Dumpster Organization )
  validates_inclusion_of :category, :in => CATEGORIES

  validates :user_id, presence: true

end
