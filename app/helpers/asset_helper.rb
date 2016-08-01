module AssetHelper
	
	def photo_asset_image_tag(item, options = {})
		if item.is_a? Array
			asset = item.first
		else
			asset = item
		end
		
		options = {
			:size => :thumb,
			:class => "#{options[:size].to_s} photo"
		}.merge(options)
		
		if asset.respond_to? :url
			image_tag asset.url(options[:size]), { :alt => asset.file_name }.merge(options)
		else
			image_tag "/images/assets/missing_#{options[:size].to_s}.png", { :class => "#{options[:size].to_s} photo", :alt => "No photo" }.merge(options)
		end
	end
	
end