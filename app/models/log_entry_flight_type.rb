class LogEntryFlightType < ActiveRecord::Base
  belongs_to :log_entry
  belongs_to :flight_type
end
