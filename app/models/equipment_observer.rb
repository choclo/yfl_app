class EquipmentObserver < ActiveRecord::Observer
  def before_save(equipment)
    # Convert air time hours to minutes if entered in hours
    if equipment.starting_air_time_unit == "hours"
      equipment.starting_air_time *= 60 # Convert hours to minutes
    end
    
    # Slugify the equipment
    equipment.slug = equipment.name.slugify
  end
end