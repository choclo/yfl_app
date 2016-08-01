class AircraftType < ActiveRecord::Base
  default_scope :order => 'display_order ASC'
  
  def equipment_categories
    equipment_category_ids = EquipmentCategoryAircraftType.find_all_by_aircraft_type_id(id).collect { |ecat| ecat.equipment_category_id }
    EquipmentCategory.find(:all, :conditions => { :id => equipment_category_ids })
  end
  
end
