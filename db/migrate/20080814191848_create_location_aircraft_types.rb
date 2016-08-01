class CreateLocationAircraftTypes < ActiveRecord::Migration
  def self.up
    create_table :location_aircraft_types do |t|
      t.integer :location_id
      t.integer :aircraft_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :location_aircraft_types
  end
end
