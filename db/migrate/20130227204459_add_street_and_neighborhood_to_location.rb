class AddStreetAndNeighborhoodToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :street, :string
    add_column :locations, :neighborhood, :string
  end
end
