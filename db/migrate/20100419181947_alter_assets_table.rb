class AlterAssetsTable < ActiveRecord::Migration
  def self.up
    rename_column :assets, :data_file_name, :remote_data_file_name
    rename_column :assets, :data_content_type, :remote_data_content_type
    rename_column :assets, :data_file_size, :remote_data_file_size
    rename_column :assets, :data_updated_at, :remote_data_updated_at
    
    add_column :assets, :local_data_file_name, :string
    add_column :assets, :local_data_content_type, :string
    add_column :assets, :local_data_file_size, :integer
    add_column :assets, :local_data_updated_at, :datetime
    add_column :assets, :processing, :boolean, :default => true
  end

  def self.down
    rename_column :assets, :remote_data_file_name, :data_file_name
    rename_column :assets, :remote_data_content_type, :data_content_type
    rename_column :assets, :remote_data_file_size, :data_file_size
    rename_column :assets, :remote_data_updated_at, :data_updated_at

    remove_column :assets, :local_data_file_name
    remove_column :assets, :local_data_content_type
    remove_column :assets, :local_data_file_size
    remove_column :assets, :local_data_updated_at
    remove_column :assets, :processing
  end
end
