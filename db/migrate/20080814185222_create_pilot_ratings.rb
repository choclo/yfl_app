class CreatePilotRatings < ActiveRecord::Migration
  def self.up
    create_table :pilot_ratings do |t|
      t.integer :pilot_id
      t.integer :rating_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pilot_ratings
  end
end
