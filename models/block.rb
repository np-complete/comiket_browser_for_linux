class Block < ActiveRecord::Base
  attr_accessor :day
  attr_accessible :name

  validates :name, uniqueness: true

  def next_block_id(day = nil)
    circles = Circle.where(day: day || @day, comiket_no: comiket_no).where("block_id > ?", id).order("block_id asc").limit(1)
    return nil if circles.count == 0
    circles.first.block_id
  end

  def prev_block_id(day = nil)
    circles = Circle.where(day: day || @day, comiket_no: comiket_no).where("block_id < ?", id).order("block_id desc").limit(1)
    return nil if circles.count == 0
    circles.first.block_id
  end

end
