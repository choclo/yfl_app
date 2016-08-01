class Equipment < ActiveRecord::Base  
  strip_attributes!
  
  belongs_to :pilot
  belongs_to :equipment_category

  has_many_polymorphic_assets :type => :photo_assets
  
  validates_presence_of :name
  validates_uniqueness_of :slug, :scope => [:pilot_id, :equipment_category_id]
  validates_numericality_of :starting_air_time, :greater_or_equal_to => 0, :message => "cannot be less than 0 minutes or hours"
  validates_inclusion_of :starting_air_time_unit, :in => %w( minutes hours ), :message => "Air time must be in minutes or hours"
  validates_length_of :notes, :maximum => 1024, :allow_blank => true, :allow_nil => true
  
  def total_air_time_as_minutes
      (self.starting_air_time || 0) + (self.air_time_minutes || 0)
  end
  
end
  