class CreateUnknowns < ActiveRecord::Migration
  def self.up
    create_table :unknowns do |t|
      t.string :name
      t.string :author
      t.text :memo
      t.integer :color_id
      t.integer :comiket_no
      t.timestamps
    end
    add_index :unknowns, :comiket_no
    add_index :unknowns, :name
    add_index :unknowns, :author
  end

  def self.down
    drop_table :unknowns
  end
end
