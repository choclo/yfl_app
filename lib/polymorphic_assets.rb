module PolymorphicAssets
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    # Extends the model to afford the ability to associate other records with the receiving record.
    # 
    # This module needs the paperclip plugin to work
    # http://www.thoughtbot.com/projects/paperclip
    def has_many_polymorphic_assets(options = {})
      write_inheritable_attribute(:has_many_polymorphic_assets_options, {
        :counter_cache => options[:counter_cache],
        :styles => options[:styles],
        :type => options[:type] || :assets
      })
      class_inheritable_reader :has_many_polymorphic_assets_options
      
      has_many has_many_polymorphic_assets_options[:type], 
              :as => :attachable, 
              :dependent => :destroy

      validates_associated has_many_polymorphic_assets_options[:type]
      
      # Virtual attribute for the ActionController::UploadedStringIO
      # which consists of these attributes "content_type", "original_filename" & "original_path"
      # content_type: image/png
      # original_filename: 64x16.png
      # original_path: 64x16.png
      attr_accessor :data
      
      include PolymorphicAssets::InstanceMethods
    end
    
    def has_one_polymorphic_assets(options = {})
      write_inheritable_attribute(:has_many_polymorphic_assets_options, {
        :counter_cache => options[:counter_cache],
        :styles => options[:styles],
        :type => options[:type] || :assets
      })
      class_inheritable_reader :has_many_polymorphic_assets_options
      
      has_one has_many_polymorphic_assets_options[:type], 
              :as => :attachable, 
              :dependent => :destroy

      validates_associated has_many_polymorphic_assets_options[:type]

      # Virtual attribute for the ActionController::UploadedStringIO
      # which consists of these attributes "content_type", "original_filename" & "original_path"
      # content_type: image/png
      # original_filename: 64x16.png
      # original_path: 64x16.png
      attr_accessor :data
      
      include PolymorphicAssets::InstanceMethods
    end
  end
  module InstanceMethods    
    
    def get_asset_type_class
      Object.const_get has_many_polymorphic_assets_options[:type].to_s.singularize.classify
    end
    
    def after_save
      super

      the_asset_type = get_asset_type_class
    
      the_asset_type.transaction do
        if data.is_a?(Array)
          data.each do |data_item|
            create_and_save_asset(data_item) unless data_item.nil? || data_item.blank?
          end
        else
          create_and_save_asset(data)
        end
      end unless data.nil? || data.blank?
    end
    
    def create_and_save_asset(data_item)
      the_asset_type = get_asset_type_class
      
      the_asset = the_asset_type.find_or_initialize_by_data_file_name(:data_file_name => data_item.original_filename, :attachable_type => self.class.to_s, :attachable_id => self.id, :pilot_id => self.pilot_id)
      
      override_default_styles, normalised_styles = override_default_styles?(data_item.original_filename)
      the_asset.data.instance_variable_set("@styles", normalised_styles) if override_default_styles
      the_asset.data = data_item
      
      if the_asset.save
        data_item = nil

        # implicit reloading
        self.send(has_many_polymorphic_assets_options[:type], true)
      end
    end
    
    def override_default_styles?(filename)
      if !has_many_polymorphic_assets_options[:styles].nil?
        normalised_styles = {}
        has_many_polymorphic_assets_options[:styles].each do |name, args|
          dimensions, format = [args, nil].flatten[0..1]
          format = nil if format.blank?
          if filename.match(/\.pdf$/) # remove crop commands if file is a PDF (this fails with Imagemagick)
            args.gsub!(/#/ , "")
            format = "png"
          end
          normalised_styles[name] = { :processors => [:thumbnail], :geometry => dimensions, :format => format }
        end
        return true, normalised_styles
      else
        return false
      end
    end
  end
end