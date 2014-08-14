class Circle < ActiveRecord::Base
  validates :circle_id, presence: true
  validates :name, presence: true
  validates :block_id, presence: true
  validates :space_no, presence: {scoped: [:comiket_no, :day]}

  belongs_to :block
  has_one :checklist
end
