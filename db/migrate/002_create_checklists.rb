class CreateChecklists < ActiveRecord::Migration
  def self.up
    create_table :checklists do |t|
      t.integer :comiket_no
      t.integer :circle_id
      t.integer :color_id
      t.text    :memo
      t.timestamps
    end
    add_index :checklists, [:comiket_no, :circle_id]
    add_index :checklists, :color_id
  end

  def self.down
    drop_table :checklists
  end
end
