class AddTotalAirtimeMinutesColumnToEquipment < ActiveRecord::Migration
  def self.up
    add_column :equipment, :air_time_minutes, :integer
  end

  def self.down
    remove_column :equipment, :air_time_minutes
  end
end
