class Pilot < ActiveRecord::Base  
  strip_attributes!
  
  # Relationships  
  belongs_to :user
  
  has_one :preferences, :dependent => :destroy

  has_one :starting_log_entry, :dependent => :destroy
    
  has_many :locations, :dependent => :destroy
  has_many :log_entries, :dependent => :destroy
  has_many :equipment, :dependent => :destroy, :conditions => { :deleted => false }
  
  named_scope :current_equipment, :conditions => { :deleted => false }
  
  has_many :pilot_licenses
  has_many :licenses, :through => :pilot_licenses
    

  # Validations
  validates_length_of :name, :minimum => 2
  validates_length_of :name, :maximum => 128  
  
  validates_presence_of :name
  validates_presence_of :country

  validates_associated :starting_log_entry
  
  
  # Filters
  after_update :save_starting_log_entry
  
  
  # Accessors
  
  # Does this pilot hold licenses for more than one type of aircraft
  def can_fly_many_aircraft_types
    return false if self.licenses.nil?
    return self.licenses.count(:all, :select => 'DISTINCT aircraft_type_id') > 1
  end
  
  # What types of aircraft is this pilot rated to fly
  def flyable_aircraft_types
    licensed_aircraft_type_ids = self.licenses.find(:all, :select => 'DISTINCT aircraft_type_id').collect { |r| r.aircraft_type_id }
    return AircraftType.find(:all, :conditions => ['id IN (?)', licensed_aircraft_type_ids]) || []
  end
  
  def total_number_of_flights
    return (self.log_entries ? self.log_entries.sum('number_of_flights') : 0)
  end
  
  def total_air_time
    return (self.log_entries ? self.log_entries.sum('air_time') : 0)
  end
  
  private
  
  def save_starting_log_entry
    self.starting_log_entry.save(false)
  end

end
