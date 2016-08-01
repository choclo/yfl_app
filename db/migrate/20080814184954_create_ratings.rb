class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :display_order, :default => 0
      t.integer :aircraft_type_id
      t.string :identifier
      t.string :name
      t.string :description
      t.string :country

      t.timestamps
    end
  end

  def self.down
    drop_table :ratings
  end
end
