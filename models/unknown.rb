class Unknown < ActiveRecord::Base
  validates :name, presence: true
  validates :author, presence: true
  validates :color_id, presence: true
end
