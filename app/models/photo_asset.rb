class PhotoAsset < Asset
  
  has_attached_file :remote_data,
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => ":pilot_id/:attachable_type/:attachable_id/:id_:style.:extension",
    :default_url => "/images/assets/missing_:style.png",
    :bucket => APP_CONFIG[:upload_asset_bucket],
    :styles => STYLES,
    :default_style => :small

#  validates_attachment_content_type :local_data, 
#    :content_type => ['image/jpg','image/jpeg','image/gif','image/png'],
#    :message => "Oops! Make sure you are uploading an image file."

end