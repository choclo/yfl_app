class CreateAircraftTypes < ActiveRecord::Migration
  def self.up
    create_table :aircraft_types do |t|
      t.integer :display_order, :default => 0
      t.string :slug, :limit => 16
      t.string :name, :limit => 32
      t.string :description, :limit => 128

      t.timestamps
    end
  end

  def self.down
    drop_table :aircraft_types
  end
end
