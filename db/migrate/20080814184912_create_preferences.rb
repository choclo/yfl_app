class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.integer :pilot_id
      t.string :distance_unit
      t.string :speed_unit
      t.string :height_unit
      t.string :language
      t.string :time_zone
      t.string :date_format

      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end
