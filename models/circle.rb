class Circle < ActiveRecord::Base
  attr_accessible :circle_id, :name, :name_kana, :book, :description, :block_id, :comiket_no, :day, :space_no, :author, :page, :cut_index, :genre_code
  belongs_to :block
  has_one :checklist
end
