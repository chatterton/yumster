class Tip < ActiveRecord::Base
  attr_accessible :text
  belongs_to :user
  belongs_to :location, :counter_cache => true
  validates_presence_of :text, :location_id, :user_id
  validates_uniqueness_of :user_id, :scope => :location_id
  validates_length_of :text, :minimum => 5, :maximum => 200
end
