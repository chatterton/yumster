class Tip < ActiveRecord::Base
  attr_accessible :text, :user_id
  attr_readonly :location_id
  belongs_to :user
  belongs_to :location
  validates_presence_of :text
  validates_uniqueness_of :user_id, :scope => :location_id
end
