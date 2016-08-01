class Location < ActiveRecord::Base
  acts_as_mappable
  strip_attributes!

  has_many_polymorphic_assets :type => :photo_assets
  
  # Set pagination limits
  cattr_reader :per_page
  @@per_page = 30
    
  # Relationships
  belongs_to :pilot  
  
  # Validations
  validates_presence_of :name, :message => "is required. You can't have a location and not know what it's called!"
  validates_numericality_of :altitude_masl, :greater_than_or_equal_to => 0, :message => "must be above sea level.", :allow_nil => true
  validates_length_of :description, :maximum => 1024, :allow_blank => true, :allow_nil => true
  validates_length_of :address1, :maximum => 128, :allow_blank => true, :allow_nil => true
  validates_length_of :address2, :maximum => 128, :allow_blank => true, :allow_nil => true
  validates_length_of :address3, :maximum => 128, :allow_blank => true, :allow_nil => true
  
  validates_uniqueness_of :name, :scope => :pilot_id
  
end
