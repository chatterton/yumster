class Location < ActiveRecord::Base
  attr_accessible :created_at, :description, :latitude, :longitude
end
