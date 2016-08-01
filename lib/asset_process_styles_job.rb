class AssetProcessStylesJob < Struct.new(:asset_id)
  def perform
    asset = Asset.find(asset_id)
    
    puts "Reprocessing #{asset_id}"
    asset.local_data.reprocess!
  end
end