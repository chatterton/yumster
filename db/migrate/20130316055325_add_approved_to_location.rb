class AddApprovedToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :approved, :boolean, :default => false
  end
  def self.down
    remove_column :locations, :approved
  end
end
