class Tip < ActiveRecord::Base
  attr_accessible :text
  belongs_to :user
  belongs_to :location
  validates_presence_of :text, :location_id, :user_id
  validates_uniqueness_of :user_id, :scope => :location_id
end
