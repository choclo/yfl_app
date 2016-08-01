class CreateLocationWindDirections < ActiveRecord::Migration
  def self.up
    create_table :location_wind_directions do |t|
      t.integer :location_id
      t.integer :wind_direction_id

      t.timestamps
    end
  end

  def self.down
    drop_table :location_wind_directions
  end
end
