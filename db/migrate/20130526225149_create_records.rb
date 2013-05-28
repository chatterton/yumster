class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :data_key
      t.integer :import_id

      t.timestamps
    end
    add_index :records, :import_id
    add_index :records, :data_key
  end
end
