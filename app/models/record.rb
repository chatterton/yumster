class Record < ActiveRecord::Base
  belongs_to :import
  attr_accessible :data_key
  has_one :location
end
