class CreateCircle < ActiveRecord::Migration
  def change
    create_table :circles do |t|
      t.integer :comiket_no
      t.integer :day
      t.integer :block_id
      t.integer :space_no
      t.string  :name
      t.string  :author
      t.string  :book
      t.text    :description
      t.timestamps
    end
    add_index :circles, :name
    add_index :circles, [:comiket_no, :day, :block_id, :space_no], :name => :circle_space
  end
end

