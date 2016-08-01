class RenameRatingToLicense < ActiveRecord::Migration
  def self.up
    rename_table :ratings, :licenses
    rename_table :pilot_ratings, :pilot_licenses
    rename_table :log_entry_ratings, :log_entry_licenses
    rename_column :pilot_licenses, :rating_id, :license_id 
    rename_column :log_entry_ratings, :rating_id, :license_id 
  end

  def self.down
    rename_column :log_entry_ratings, :license_id, :rating_id
    rename_column :pilot_licenses, :license_id, :rating_id
    rename_table :log_entry_licenses, :log_entry_ratings
    rename_table :pilot_licenses, :pilot_ratings
    rename_table :licenses, :ratings
  end
end
