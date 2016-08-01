require 'polymorphic_assets'
ActiveRecord::Base.send(:include, PolymorphicAssets)

Paperclip.interpolates :pilot_id do |attachment, style|
  attachment.instance.pilot_id
end

Paperclip.interpolates :attachable_type do |attachment, style|
  attachment.instance.attachable_type.downcase
end

Paperclip.interpolates :attachable_id do |attachment, style|
  attachment.instance.attachable_id
end