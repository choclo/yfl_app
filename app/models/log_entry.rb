class LogEntry < ActiveRecord::Base    
  attr_protected :average_wind_speed
  strip_attributes!
  
  default_scope :order => 'date DESC'
  
  # Set pagination limits
  cattr_reader :per_page
  @@per_page = 30
  
  # Relationships
  belongs_to :pilot
  belongs_to :location
  
  belongs_to :aircraft_type
  
  has_many :log_entry_equipment, :dependent => :destroy
  has_many :equipment, :through => :log_entry_equipment

  has_many :log_entry_launch_types, :dependent => :destroy
  has_many :launch_types, :through => :log_entry_launch_types
  
  has_many :log_entry_flight_types, :dependent => :destroy
  has_many :flight_types, :through => :log_entry_flight_types

  has_many :log_entry_wind_directions, :dependent => :destroy
  has_many :wind_directions, :through => :log_entry_wind_directions
  
  has_many :log_entry_licenses, :dependent => :destroy
  has_many :licenses, :through => :log_entry_licenses

  has_many_polymorphic_assets :type => :photo_assets
  
  # Validations
  validates_presence_of :location_id, :date, :air_time
  validates_numericality_of :number_of_flights, :greater_than => 0, :message => "must be at least 1", :unless => :is_starting_log_entry?
  validates_numericality_of :air_time, :greater_than => 0, :message => "cannot be 0", :unless => :is_starting_log_entry?
  validates_numericality_of :distance, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :height_gain, :allow_nil => true
  validates_numericality_of :minimum_wind_speed, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :average_wind_speed, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_numericality_of :maximum_wind_speed, :greater_than_or_equal_to => 0, :allow_nil => true
  validates_length_of :note, :maximum => 1024, :allow_blank => true, :allow_nil => true
  validates_inclusion_of :air_time_unit, :in => %w( minutes hours ), :message => "Air time unit must be in minutes or hours"
    
  # Filters
  before_destroy :ensure_starting_log_entry_cannot_be_destroyed
  
  def ensure_starting_log_entry_cannot_be_destroyed
    raise StartingLogEntryCannotBeDestroyed.new if is_starting_log_entry?
  end

  # Accept cardinals (e.g. 'N','NE') instead of just the WindDirection ids
  def wind_direction_cardinals=(cardinals)
    @wind_direction_cardinals = cardinals
    self.wind_directions = WindDirection.find(:all, :conditions => ["cardinal IN (?)", @wind_direction_cardinals])
  end
  
  def wind_direction_cardinals
    @wind_direction_cardinals || wind_directions.all.collect {|wd| wd.cardinal }
  end
  
  # Is this log entry the StartingLogEntry created in the Pilot setup wizard?
  def is_starting_log_entry?
    self.location_id == -1
  end

end

class StartingLogEntryCannotBeDestroyed < Exception
end
