class Checklist < ActiveRecord::Base
  attr_accessible :circle_id, :comiket_no, :color_id, :memo
  validates :circle_id, uniqueness: {:scope => :comiket_no}
  validates :comiket_no, presence: true
  belongs_to :circle
end
