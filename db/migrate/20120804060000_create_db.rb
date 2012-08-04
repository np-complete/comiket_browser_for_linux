class CreateDb < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.integer :comiket_no
      t.string :name
      t.integer :map_id
      t.integer :x
      t.integer :y
      t.integer :w
      t.integer :h
      t.string :filename
      t.integer :x2
      t.integer :y2
      t.integer :w2
      t.integer :h2
      t.timestamps
    end
    add_index :areas, [:comiket_no, :map_id]

    create_table :circles do |t|
      t.integer :comiket_no
      t.integer :page_no
      t.integer :cut_index
      t.integer :day
      t.integer :block_id
      t.integer :space_no
      t.integer :space_no_sub
      t.integer :genre_id
      t.string :name
      t.string :kana
      t.string :author
      t.string :book
      t.string :url
      t.string :mail
      t.text :description
      t.text :memo
      t.integer :update_id
      t.string :circlems
      t.string :rss
      t.integer :update_flag
      t.timestamps
    end
    add_index :circles, :kana
    add_index :circles, :name
    add_index :circles, [:comiket_no, :page_no]
    add_index :circles, [:comiket_no, :day, :block_id]
    add_index :circles, [:comiket_no, :update_id]

    create_table :blocks do |t|
      t.integer :comiket_no
      t.string :name
      t.integer :area_id
      t.timestamps
    end
    add_index :blocks, [:comiket_no, :area_id, :name]

    create_table :maps do |t|
      t.integer :comiket_no
      t.string :name
      t.string :filename
      t.integer :x
      t.integer :y
      t.integer :w
      t.integer :h
      t.string :all_filename
      t.integer :x2
      t.integer :y2
      t.integer :w2
      t.integer :h2
      t.integer :rotate
      t.timestamps
    end

    create_table :comikets do |t|
      t.integer :comiket_no
      t.string :name
      t.integer :cutsize_w
      t.integer :cutsize_h
      t.integer :origin_x
      t.integer :origin_y
      t.integer :offset_x
      t.integer :offset_y
      t.integer :map_w
      t.integer :map_h
      t.integer :map_origin_x
      t.integer :map_origin_y
    end
    add_index :comikets, :comiket_no
  end
end

