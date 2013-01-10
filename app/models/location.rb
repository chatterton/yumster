class Location < ActiveRecord::Base
  attr_accessible :description, :latitude, :longitude
end
