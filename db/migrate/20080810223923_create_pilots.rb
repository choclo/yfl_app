class CreatePilots < ActiveRecord::Migration
  def self.up
    create_table :pilots do |t|
      t.integer :user_id
      t.string :name, :limit => 128
      #t.string :city, :limit => 64
      t.string :country, :limit => 64
      t.string :membership_id, :limit => 128
      t.boolean :completed_setup, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :pilots
  end
end
