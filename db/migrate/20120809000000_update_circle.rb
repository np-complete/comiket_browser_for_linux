class UpdateCircle < ActiveRecord::Migration
  def change
    change_table :circles do |t|
      t.integer :circle_id
      t.string :name_kana
      t.integer :cut_index
      t.integer :genre_code
      t.integer :page
    end
    add_index :circles, [:comiket_no, :circle_id]
  end
end
