class AddColumnsToRatingTable < ActiveRecord::Migration
  def self.up
    add_column :ratings, :suggested, :boolean, :default => false
    add_column :ratings, :pilot_id, :integer, :default => nil
  end

  def self.down
    remove_column :ratings, :pilot_id
    remove_column :ratings, :suggested
  end
end
