class EquipmentCategory < ActiveRecord::Base
  has_many :equipment, :order => "display_order DESC, name ASC"
  
  has_many :equipment_category_aircraft_types, :dependent => :destroy
  has_many :aircraft_types, :through => :equipment_category_aircraft_types
  
#  validates_uniqueness_of :slug
end
