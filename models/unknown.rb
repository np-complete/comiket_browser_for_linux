class Unknown < ActiveRecord::Base
  attr_accessible :name, :author, :color_id, :memo
  validates :name, presence: true
  validates :author, presence: true
end
