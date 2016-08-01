require 'fileutils'

class AssetDeleteTempFilesJob < Struct.new(:asset_id)
  def perform
    asset = Asset.find(asset_id)

    # Upload all styles to S3
    if asset.local_data
      temp_path = asset.local_data.path
      
      dir = File.dirname(temp_path)
      puts "Deleting files from #{dir}"
      Dir.foreach(dir) do |f|
        if f == '.' or f == '..' then 
          next
        else 
          puts "- #{f}"
          FileUtils.rm( f )
        end
      end
      
    else
      puts '!'*10 + "No local_data found, cannot delete files"
    end
  end
end