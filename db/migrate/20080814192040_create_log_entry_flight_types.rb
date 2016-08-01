class CreateLogEntryFlightTypes < ActiveRecord::Migration
  def self.up
    create_table :log_entry_flight_types do |t|
      t.integer :pilot_id
      t.integer :log_entry_id
      t.integer :flight_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :flight_flight_types
  end
end
