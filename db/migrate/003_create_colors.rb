class CreateColors < ActiveRecord::Migration
  def self.up
    create_table :colors do |t|
      t.string :color
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :colors
  end
end
