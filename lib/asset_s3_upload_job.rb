class AssetS3UploadJob < Struct.new(:asset_id)
  def perform
    asset = Asset.find(asset_id)

    puts "Uploading #{asset_id}"
    
    # Upload all styles to S3
    if asset.local_data
      temp_path = asset.local_data.path
      temp_file = asset.local_data.to_file # Paperclips way of getting a File object for the attachment
      
      asset.remote_data = temp_file
      
      asset.processing = false
      asset.save(false)

      temp_file.close if temp_file
    else
      puts '!'*10 + "No local_data found, cannot upload"
    end
  end
end