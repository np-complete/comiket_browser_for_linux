ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'db/comiket.sqlite3')

class Circle < ActiveRecord::Base
  attr_accessible :id, :name, :book, :description, :block, :comiket_no, :day, :space_no, :area, :author

end
