class CreateUnknown < ActiveRecord::Migration
  def change
    create_table :unknowns do |t|
      t.string :name
      t.string :author
      t.text :memo
      t.integer :color_id
      t.timestamps
    end
    add_index :unknowns, :name
    add_index :unknowns, :author
  end
end
