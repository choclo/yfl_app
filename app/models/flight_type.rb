class FlightType < ActiveRecord::Base

  default_scope :order => "display_order ASC"

end
