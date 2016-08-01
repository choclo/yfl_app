class CreateLogEntries < ActiveRecord::Migration
  def self.up
    create_table :log_entries do |t|
      # Single Table Inheritence
      t.string :type
      
      t.integer :pilot_id, :null => false
      t.integer :location_id
      t.integer :aircraft_id
      t.date :date, :null => false
      t.datetime :start_time, :null => true
      t.datetime :end_time, :null => true
      t.decimal :air_time, :default => 0, :null => false
      t.string :air_time_unit, :limit => 16, :default => "minutes", :null => false
      t.integer :number_of_flights, :default => 1, :null => false
      t.decimal :minimum_wind_speed, :null => true
      t.decimal :average_wind_speed, :null => true
      t.decimal :maximum_wind_speed, :null => true
      t.decimal :height_gain, :null => true
      t.decimal :distance, :null => true
      t.string :note, :null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :log_entries
  end
end
