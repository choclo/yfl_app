class EquipmentCategoryAircraftType < ActiveRecord::Base
  belongs_to :equipment_category
  belongs_to :aircraft_type
end
