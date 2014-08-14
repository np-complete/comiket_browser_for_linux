class Color < ActiveRecord::Base
  validates :color, presence: true
  validates :title, presence: true
end
