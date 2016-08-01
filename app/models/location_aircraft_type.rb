class LocationAircraftType < ActiveRecord::Base
  belongs_to :location
  belongs_to :aircraft_type
end
