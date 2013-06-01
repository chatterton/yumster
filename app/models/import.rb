class Import < ActiveRecord::Base
  attr_accessible :credit_line, :name, :import_type
  has_many :records, :dependent => :destroy
end
