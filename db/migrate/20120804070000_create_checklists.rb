class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.integer :comiket_no
      t.integer :circle_id
      t.integer :color_id
      t.text    :memo
      t.timestamps
    end
    add_index :checklists, [:comiket_no, :circle_id]
    add_index :checklists, :color_id


    create_table :colors do |t|
      t.string :color
      t.string :title
      t.timestamps
    end
  end
end
