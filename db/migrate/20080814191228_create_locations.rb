class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer :pilot_id, :null => false
      t.decimal :lat, :null => true, :default => nil, :precision => 15, :scale => 12
      t.decimal :lng, :null => true, :default => nil, :precision => 15, :scale => 12
      t.decimal :altitude_masl, :null => false, :default => 0
      t.string :name, :limit => 128, :null => false
      t.string :address1, :limit => 128, :null => true
      t.string :address2, :limit => 128, :null => true
      t.string :address3, :limit => 128, :null => true
      t.string :country, :limit => 128
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
