class CreateLogEntryWindDirections < ActiveRecord::Migration
  def self.up
    create_table :log_entry_wind_directions do |t|
      t.integer :pilot_id
      t.integer :log_entry_id
      t.integer :wind_direction_id

      t.timestamps
    end
  end

  def self.down
    drop_table :flight_wind_directions
  end
end
