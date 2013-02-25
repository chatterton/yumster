class AddTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.integer :user_id
      t.integer :location_id
      t.string :text
      t.timestamps
    end
    add_index :tips, :user_id
    add_index :tips, :location_id
    add_index :tips, [:user_id, :location_id], unique: true
  end
end
