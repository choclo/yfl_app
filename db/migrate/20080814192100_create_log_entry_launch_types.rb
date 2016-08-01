class CreateLogEntryLaunchTypes < ActiveRecord::Migration
  def self.up
    create_table :log_entry_launch_types do |t|
      t.integer :pilot_id
      t.integer :log_entry_id
      t.integer :launch_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :flight_launch_types
  end
end
