class LogEntryObserver < ActiveRecord::Observer
  def before_save(log_entry)
    # Convert air time hours to minutes if entered in hours
    if log_entry.air_time_unit == "hours"
      log_entry.air_time *= 60 # Convert hours to minutes
    end
    
    # Convert distance units back to the base units from the users preference units.
    if log_entry.pilot.preferences.speed_unit != UNITS[:kilometers_per_hour]
      log_entry.minimum_wind_speed *= UNITS[:conversions][:speed]["#{log_entry.pilot.preferences.speed_unit}_to_kmph"] if not log_entry.minimum_wind_speed.nil?
      log_entry.maximum_wind_speed *= UNITS[:conversions][:speed]["#{log_entry.pilot.preferences.speed_unit}_to_kmph"] if not log_entry.maximum_wind_speed.nil?
    end

    # Convert speed units back to the base units from the users preference units.    
    if log_entry.pilot.preferences.distance_unit != UNITS[:kilometers]
      log_entry.distance *= UNITS[:conversions][:distance]["#{log_entry.pilot.preferences.distance_unit}_to_km"] if not log_entry.distance.nil?
    end
    
    # Convert height units back to the base units from the users preference units.
    if log_entry.pilot.preferences.height_unit != UNITS[:meters]
      log_entry.height_gain *= UNITS[:conversions][:height]["#{log_entry.pilot.preferences.height_unit}_to_m"] if not log_entry.height_gain.nil?
    end
    
    # Calculate the average_wind_speed
    if log_entry.minimum_wind_speed && log_entry.maximum_wind_speed
      log_entry.average_wind_speed = (log_entry.minimum_wind_speed + log_entry.maximum_wind_speed) / 2
    else
      log_entry.average_wind_speed = nil
    end
  end
  
  def after_save(log_entry)
    # Save all the HMT models
    log_entry.log_entry_equipment.each do |equipment|
      equipment.save(false)
    end
    log_entry.log_entry_launch_types.each do |launch|
      launch.save(false)
    end
    log_entry.log_entry_flight_types.each do |flight|
      flight.save(false)
    end
    log_entry.log_entry_wind_directions.each do |wind|
      wind.save(false)
    end
    
    # Only save the pilots current licenses on creation of the log entry
    if log_entry.new_record?
      log_entry.log_entry_licenses.each do |license|
        license.save(false)
      end
    end
  end
end