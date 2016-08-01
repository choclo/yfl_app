class Bootstrap < ActiveRecord::Migration
  def self.up
    # Aircraft type
    pg = AircraftType.create :slug => "pg", :name => "Paraglider", :description => "Paraglider"
    ppg = AircraftType.create :slug => "ppg", :name => "Powered Paraglider", :description => "Powered Paraglider"
    hg = AircraftType.create :slug => "hg", :name => "Hang Glider", :description => "Hang Glider"
    
    # Launch types
    LaunchType.create :aircraft_type_id => pg.id, :name => 'Hill (forward/alpine)', :description => "Hill launch using the forward, otherwise known as alpine, launch method (usually used in light winds or at high altitudes)"
    LaunchType.create :aircraft_type_id => pg.id, :name => 'Hill (reverse)', :description => "Hill launch using the reverse launch method (usually used in medium to strong wings)"
    LaunchType.create :aircraft_type_id => pg.id, :name => "Tow", :description => "Launched from a towing winch"

    LaunchType.create :aircraft_type_id => ppg.id, :name => 'Ground (flat)', :description => "Ground launch"    
    LaunchType.create :aircraft_type_id => ppg.id, :name => 'Hill (forward/alpine)', :description => "Hill launch using the forward, otherwise known as alpine, launch method (usually used in light winds or at high altitudes)"
    LaunchType.create :aircraft_type_id => ppg.id, :name => 'Hill (reverse)', :description => "Hill launch using the reverse launch method (usually used in medium to strong wings)"
    LaunchType.create :aircraft_type_id => ppg.id, :name => "Tow", :description => "Launched from a towing winch"
    
    LaunchType.create :aircraft_type_id => hg.id, :name => "Hill", :description => "Hill launch"
    LaunchType.create :aircraft_type_id => hg.id, :name => "Tow", :description => "Launched from a towing winch"
    
    # Flight types
    FlightType.create :aircraft_type_id => pg.id, :name => "Ridge soaring", :description => "Ridge soaring or Ridge lift"
    FlightType.create :aircraft_type_id => pg.id, :name => "Thermals", :description => "Thermals"
    FlightType.create :aircraft_type_id => pg.id, :name => "Cross Country (XC)", :description => "Cross Country flying, typically using thermals as lift"
    FlightType.create :aircraft_type_id => pg.id, :name => "Acrobatics", :description => "Acrobatics"
    FlightType.create :aircraft_type_id => pg.id, :name => "SIV", :description => "SIV maneuvours, usually part of a SIV training course"

    FlightType.create :aircraft_type_id => ppg.id, :name => "Powered", :description => "Powered flight using an engine"    
    FlightType.create :aircraft_type_id => ppg.id, :name => "Ridge soaring", :description => "Ridge soaring or Ridge lift"
    FlightType.create :aircraft_type_id => ppg.id, :name => "Thermals", :description => "Thermals"
    FlightType.create :aircraft_type_id => ppg.id, :name => "Cross Country (XC)", :description => "Cross Country flying, typically using thermals as lift"

    FlightType.create :aircraft_type_id => hg.id, :name => "Ridge soaring", :description => "Ridge soaring or Ridge lift"
    FlightType.create :aircraft_type_id => hg.id, :name => "Thermals", :description => "Thermals"
    FlightType.create :aircraft_type_id => hg.id, :name => "Cross Country (XC)", :description => "Cross Country flying, typically using thermals as lift"
    FlightType.create :aircraft_type_id => hg.id, :name => "Acrobatics", :description => "Acrobatics"
    
    # Wind directions
    WindDirection.create :cardinal => "N", :direction => "North"
    WindDirection.create :cardinal => "NE", :direction => "North East"
    WindDirection.create :cardinal => "NW", :direction => "North West"
    WindDirection.create :cardinal => "S", :direction => "South"
    WindDirection.create :cardinal => "SE", :direction => "South East"
    WindDirection.create :cardinal => "SW", :direction => "South West"
    WindDirection.create :cardinal => "E", :direction => "East"
    WindDirection.create :cardinal => "W", :direction => "West"
    
    # Equipment Categories
    pgglider = EquipmentCategory.create :aircraft_type_ids => [pg.id], :slug => "wing", :name => "Paraglider Wing", :description => "Paraglider wing", :display_order => 2
    pgharness = EquipmentCategory.create :aircraft_type_ids => [pg.id], :slug => "harness", :name => "Harness", :description => "Paraglider Harness", :display_order => 1

    EquipmentCategory.create :aircraft_type_ids => [ppg.id], :slug => "wing", :name => "Powered Paraglider Wing", :description => "Powered Paraglider (Paramotor, or PPG) Wing", :display_order => 3
    EquipmentCategory.create :aircraft_type_ids => [ppg.id], :slug => "engine", :name => "Powered Paraglider Engine", :description => "Powered Paraglider (Paramotor, or PPG) Engine", :display_order => 2
    EquipmentCategory.create :aircraft_type_ids => [ppg.id], :slug => "harness", :name => "Harness", :description => "Powered Paraglider Harness", :display_order => 1
    
    EquipmentCategory.create :aircraft_type_ids => [pg.id, ppg.id], :slug => "reserve", :name => "Reserve", :description => "Reserve/Emergency parachute for paragliders"
        
    EquipmentCategory.create :aircraft_type_ids => [hg.id], :slug => "wing", :name => "Hang Glider Wing", :description => "Hang Glider sail", :display_order => 3
    EquipmentCategory.create :aircraft_type_ids => [hg.id], :slug => "harness", :name => "Harness", :description => "Hang Glider Harness", :display_order => 2
    EquipmentCategory.create :aircraft_type_ids => [hg.id], :slug => "reserve", :name => "Reserve", :description => "Reserve/Emergency parachute", :display_order => 1

    EquipmentCategory.create :aircraft_type_ids => [pg.id,hg.id,ppg.id], :slug => "helmet", :name => "Helmet", :description => "Helmet"
    EquipmentCategory.create :aircraft_type_ids => [pg.id,hg.id,ppg.id], :slug => "vario", :name => "Vario", :description => "Vario"
    pgradio = EquipmentCategory.create :aircraft_type_ids => [pg.id,hg.id,ppg.id], :slug => "radio", :name => "Radio", :description => "Radio"
    EquipmentCategory.create :aircraft_type_ids => [pg.id,hg.id,ppg.id], :slug => "gps", :name => "GPS", :description => "Global Positioning System navigation device"
    EquipmentCategory.create :aircraft_type_ids => [pg.id,hg.id,ppg.id], :slug => "other", :name => "Other", :description => "Other bits and pieces", :display_order => 1

    
    # PG Equipment
    Equipment.create :pilot_id => 1, :equipment_category_id => pgglider.id, :name => "Gin Zulu Explorer", :colour => "Poppy", :slug => "gin-zulu-explorer", :starting_air_time => rand(100) + 1
    Equipment.create :pilot_id => 1, :equipment_category_id => pgglider.id, :name => "Swing Arcus", :colour => "Red", :slug => "swing-arcus", :starting_air_time => rand(100) + 1
    # PG Harness
    Equipment.create :pilot_id => 1, :equipment_category_id => pgharness.id, :name => "Gin Airlight", :slug => "gin-airlight", :starting_air_time => rand(100) + 1
    # PG Radio
    Equipment.create :pilot_id => 1, :equipment_category_id => pgradio.id, :name => "Yaesu VX-1", :slug => "yaesu-vx-1", :starting_air_time => rand(100) + 1
        
    # Licenses - spaced out in 10s to give space for future licenses
    # International
#    License.create :display_order => 10, :aircraft_type => pg, :identifier => 'IPPI', :name => 'IPPI', :description => 'The International Pilot Proficiency Information (IPPI) Card', :country => ''
    
    # NZ
#    License.create :display_order => 10, :aircraft_type => pg, :identifier => 'PG1', :name => 'PG1', :description => 'Beginner paraglider license', :country => 'New Zealand'
#    License.create :display_order => 20, :aircraft_type => pg, :identifier => 'PG2', :name => 'PG2', :description => 'Intermediate paraglider license', :country => 'New Zealand'
#    License.create :display_order => 30, :aircraft_type => pg, :identifier => 'PG3', :name => 'PG3', :description => 'Advanced paraglider license', :country => 'New Zealand'
#    License.create :display_order => 40, :aircraft_type => pg, :identifier => 'PP1', :name => 'PP1', :description => 'Tamden paraglider license', :country => 'New Zealand'
  
    # UK
#    License.create :display_order => 10, :aircraft_type => pg, :identifier => "CP", :name => "CP", :description => "Club Pilot", :country => "United Kingdom"
#    License.create :display_order => 20, :aircraft_type => pg, :identifier => "PILOT", :name => "Pilot", :description => "Pilot", :country => "United Kingdom"

    # Locations
    #Location.create :pilot_id => 1, :name => "Oludeniz, middle takeoff", :description => "Middle launch at 900 meters ASL at Oludeniz, Turkey.", :country => "Turkey", :lat => nil, :lng => nil, :altitude_masl => 900
    #Location.create :pilot_id => 1, :name => "Kario", :description => "Kariotahi training hill", :address1 => "Kariotahi", :country => "New Zealand", :lat => nil, :lng => nil, :altitude_masl => 50
    
#    adam_pilot = Pilot.create :user_id => 2, :name => "Adam Burmister", :country => "New Zealand"
#    adam_pilot.ratings << pg2
    
#    Preferences.create :pilot_id => 1, :distance_unit => "km", :speed_unit => "kmph", :height_unit => "m", :language => "English", :time_zone => "UTC", :date_format => "%d/%m/%Y"
    
    # Create log entries
    # 100.times { |i|
    #   log = LogEntry.new :pilot_id => 1, 
    #               :date => Date.today - rand(1000),
    #               :note => "Randomly generated flight log entry", 
    #               :location_id => rand(2) + 1,
    #               :air_time => rand(100) + 1,
    #               :air_time_unit => "minutes",
    #               :number_of_flights => rand(10) + 1,
    #               :minimum_wind_speed => rand(20),
    #               :maximum_wind_speed => rand(45),
    #               :height_gain => rand(100),
    #               :distance => rand(100)
    #   log.save
    # }
    
  end

  def self.down
  end
end
