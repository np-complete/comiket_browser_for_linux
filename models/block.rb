class Block < ActiveRecord::Base
  attr_accessor :day
  attr_accessible :name

  validates :name, uniqueness: true

  def self.find_and_day(id, day, comiket_no = nil)
    block = Block.find(id)
    block.day = day
    block
  end

  def next_block
    @next_block ||= begin
                      circles = Circle.where(day: day || @day, comiket_no: comiket_no).where("block_id > ?", id).order("block_id asc").limit(1)
                      return nil if circles.count == 0
                      Block.find_and_day(circles.first.block_id, day)
                    end
  end

  def prev_block
    @prev_block ||= begin
                      circles = Circle.where(day: day || @day, comiket_no: comiket_no).where("block_id < ?", id).order("block_id desc").limit(1)
                      return nil if circles.count == 0
                      Block.find_and_day(circles.first.block_id, day)
                    end
  end

  def pages
    (Circle.where(day: day || @day, comiket_no: comiket_no, block_id: id).count.to_f / 16).ceil
  end
end
