ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'db/comiket.sqlite3')
ActiveRecord::Base.include_root_in_json = false

class Circle < ActiveRecord::Base
  attr_accessible :id, :name, :book, :description, :block_id, :comiket_no, :day, :space_no, :author
  belongs_to :block
  has_one :checklist

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
