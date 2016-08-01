class CreateWindDirections < ActiveRecord::Migration
  def self.up
    create_table :wind_directions do |t|
      t.string :direction, :limit => 16
      t.string :cardinal, :limit => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :wind_directions
  end
end
