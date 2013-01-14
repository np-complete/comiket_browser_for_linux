class CreateBlocks < ActiveRecord::Migration
  def self.up
    create_table :blocks do |t|
      t.integer :comiket_no
      t.string :name
      t.timestamps
    end
    add_index :blocks, :comiket_no
  end

  def self.down
    drop_table :blocks
  end
end
