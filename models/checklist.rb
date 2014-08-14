class Checklist < ActiveRecord::Base
  validates :circle_id, uniqueness: {:scope => :comiket_no}
  validates :comiket_no, presence: true
  validates :color_id, presence: true
  belongs_to :circle
end
