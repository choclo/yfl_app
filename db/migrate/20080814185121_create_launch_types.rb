class CreateLaunchTypes < ActiveRecord::Migration
  def self.up
    create_table :launch_types do |t|
      t.integer :display_order, :default => 0
      t.integer :aircraft_type_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :launch_types
  end
end
