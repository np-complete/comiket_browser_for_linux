ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'db/comiket.sqlite3')

class Circle < ActiveRecord::Base
  attr_accessible :id, :name, :book, :description, :block_id, :comiket_no, :day, :space_no, :author
  belongs_to :block
end

class Color < ActiveRecord::Base
  attr_accessible :id, :color, :title
end

class Checklist < ActiveRecord::Base
  attr_accessible :circle_id, :comiket_no, :color_id, :memo
  validates :circle_id, uniqueness: true
end

class Block < ActiveRecord::Base
  attr_accessible :name
  validates :name, uniqueness: true
end
