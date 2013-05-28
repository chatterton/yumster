class AddRecordToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :record_id, :integer
  end
end
