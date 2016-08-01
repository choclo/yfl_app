class CreateLogEntryRatings < ActiveRecord::Migration
  def self.up
    create_table :log_entry_ratings do |t|
      t.integer :pilot_id
      t.integer :log_entry_id
      t.integer :rating_id

      t.timestamps
    end
  end

  def self.down
    drop_table :log_entry_ratings
  end
end
