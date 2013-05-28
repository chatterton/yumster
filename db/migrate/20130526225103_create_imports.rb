class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :name
      t.string :import_type
      t.text :credit_line

      t.timestamps
    end
  end
end
