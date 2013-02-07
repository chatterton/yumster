class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :username

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_length_of :username, :minimum => 3, :maximum => 15
  validates_format_of :username, :with => /^[A-Za-z\d_]+$/, :message => "can only be alphanumeric, no spaces"

end
