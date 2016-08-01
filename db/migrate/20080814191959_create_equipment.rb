class CreateEquipment < ActiveRecord::Migration
  def self.up
    create_table :equipment do |t|
      t.integer :equipment_category_id
      t.integer :pilot_id
      t.boolean :deleted, :default => false
      t.string :name
      t.string :notes
      t.string :colour
      t.string :serial_number
      t.string :slug, :length => 64
      t.decimal :starting_air_time, :null => true
      t.string :starting_air_time_unit, :limit => 16, :default => "minutes", :null => false
      t.date :purchase_date

      t.timestamps
    end
  end

  def self.down
    drop_table :equipment
  end
end
