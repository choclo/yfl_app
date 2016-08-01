class CreateLogEntryEquipments < ActiveRecord::Migration
  def self.up
    create_table :log_entry_equipments do |t|
      t.integer :pilot_id
      t.integer :log_entry_id
      t.integer :equipment_id

      t.timestamps
    end
  end

  def self.down
    drop_table :flight_equipments
  end
end
