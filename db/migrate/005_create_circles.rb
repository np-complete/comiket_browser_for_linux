class CreateCircles < ActiveRecord::Migration
  def self.up
    create_table :circles do |t|
      t.integer :circle_id
      t.integer :comiket_no
      t.integer :day
      t.integer :block_id
      t.integer :space_no
      t.string  :name
      t.string  :name_kana
      t.string  :author
      t.string  :book
      t.text    :description
      t.integer :cut_index
      t.integer :genre_code
      t.integer :page
      t.timestamps
    end
    add_index :circles, :name
    add_index :circles, [:comiket_no, :day, :block_id, :space_no], :name => :circle_space
    add_index :circles, [:comiket_no, :circle_id]
  end

  def self.down
    drop_table :circles
  end
end
