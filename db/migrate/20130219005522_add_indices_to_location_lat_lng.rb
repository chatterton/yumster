class AddIndicesToLocationLatLng < ActiveRecord::Migration
  def change
    add_index :locations, :latitude
    add_index :locations, :longitude
  end
end
