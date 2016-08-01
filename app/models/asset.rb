class Asset < ActiveRecord::Base
  MAX_FILE_SIZE_ALLOWANCE = 100.megabytes
  STYLES = {
      :thumb=> "120x120#",
      :small  => "120x120>",
      :medium => "300x200>",
      :large =>   "800x600>" 
    }

  still_processing_image_path = '/images/assets/processing.png'
  
  belongs_to :attachable, :polymorphic => true
  belongs_to :pilot

  # A local copy which is used before uploading the file to S3
  has_attached_file :local_data, :styles => STYLES,
    :path => ":rails_root/public/uploads/:id/:style_:basename.:extension",
    :url => "/assets/temp_preview/:id",
    :default_url =>  "/images/assets/processing_spinner.png"
  
  has_attached_file :remote_data,
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :path => ":pilot_id/:attachable_type/:attachable_id/:id_:style.:extension",
    :bucket => APP_CONFIG[:upload_asset_bucket],
    :styles => STYLES
  
  validates_attachment_presence :local_data
  validates_attachment_size :local_data, :less_than => 2.megabyte

  validate :not_exceeded_total_file_size_limit
  
  def not_exceeded_total_file_size_limit
    total_assets_file_size = Asset.find_all_by_pilot_id(self.pilot_id).inject(0) { |sum, asset| asset.local_data_file_size } || 0
    errors.add_to_base("You have exceeded your file-storage limit. This file cannot be saved.") if total_assets_file_size > MAX_FILE_SIZE_ALLOWANCE
  end
  
  alias_method :data=, :local_data=
  def data
    if self.remote_data.nil? || processing?
      self.local_data
    else
      self.remote_data
    end
  end
  
  def url(style = :original)
    if self.remote_data.nil? || processing?
      return local_data.url(style)
    end
    remote_data.url(style)
  end

  def remote_url(*args)
    remote_data.url(*args)
  end
  
  def local_url(*args)
    local_data.url(*args)
  end
  
  def file_name
    self.remote_data_file_name.nil? ? self.local_data_file_name : self.remote_data_file_name
  end
  
  def content_type
    data.content_type || ''
  end
  
  # def name
  #   local_data_file_name
  # end
  
  # def content_type
  #   local_data_content_type
  # end
  
  def browser_safe?
    %w(jpg gif png).include?(url.split('.').last.sub(/\?.+/, "").downcase)
  end
  alias_method :web_safe?, :browser_safe?
  
  # This method will replace one of the existing thumbnails with an file provided.
  def replace_style(style, file)
    style = style.downcase.to_sym
    if data.styles.keys.include?(style)
      if File.exist?(RAILS_ROOT + '/public' + a.data(style))
      end
    end
  end

  before_local_data_post_process do |asset|
    false if asset.changed?
  end

  after_create do |asset|
    Delayed::Job.enqueue(AssetProcessStylesJob.new(asset.id)) #if asset.data.content_type =~ /^image.*/
    Delayed::Job.enqueue(AssetS3UploadJob.new(asset.id))
    Delayed::Job.enqueue(AssetDeleteTempFilesJob.new(asset.id))
  end
  
end