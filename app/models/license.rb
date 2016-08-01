class License < ActiveRecord::Base
  belongs_to :aircraft_type
  default_scope :order => 'display_order ASC'
end