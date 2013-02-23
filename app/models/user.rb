class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  has_many :locations
  has_many :tips
  has_many :tip_locations, :through => :tips, :class_name => 'Location', :source => :location

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_length_of :username, :minimum => 3, :maximum => 15
  validates_format_of :username, :with => /^[A-Za-z\d_]+$/, :message => "can only be alphanumeric, no spaces"

  # Allow username as valid login, per
  # http://stackoverflow.com/questions/2997179/ror-devise-sign-in-with-username-or-email
  def self.find_for_database_authentication(conditions={})
    self.where("username = ?", conditions[:email]).limit(1).first ||
    self.where("email = ?", conditions[:email]).limit(1).first
  end

end
