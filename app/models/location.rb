class Location < ActiveRecord::Base
  attr_accessible :description, :latitude, :longitude, :category
  attr_readonly :address, :city, :state, :state_code, :postal_code, :country, :country_code
  belongs_to :user
  has_many :tips
  has_many :users, :through => :tips

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
  validates_length_of :description, :minimum => 5, :maximum => 45

  validates :category, presence: true
  CATEGORIES = %w( Plant Dumpster Organization )
  validates_inclusion_of :category, :in => CATEGORIES

  validates :user_id, presence: true

end
