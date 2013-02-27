class AddAddressFieldsToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :address, :string
    add_column :locations, :city, :string
    add_column :locations, :state, :string
    add_column :locations, :state_code, :string
    add_column :locations, :postal_code, :string
    add_column :locations, :country, :string
    add_column :locations, :country_code, :string
  end
end
