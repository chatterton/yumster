class AddTipsCountToLocation < ActiveRecord::Migration
  def self.up
    ## Add column
    add_column :locations, :tips_count, :integer, null: false, default: 0
    ## Set counts for existing tips
    Location.all.each do |loc|
      Location.reset_counters(loc.id, :tips)
    end
  end
  def self.down
    remove_column :locations, :tips_count
  end
end
