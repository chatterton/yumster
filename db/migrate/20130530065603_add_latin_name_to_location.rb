class AddLatinNameToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :latin_name, :string
  end
end
