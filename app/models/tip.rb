class Tip < ActiveRecord::Base
  attr_accessible :text
  belongs_to :user
  belongs_to :location
  #validates_presence_of :text
end
