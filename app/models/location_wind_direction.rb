class LocationWindDirection < ActiveRecord::Base
  belongs_to :location
  belongs_to :wind_direction  
end
