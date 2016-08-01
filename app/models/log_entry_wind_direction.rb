class LogEntryWindDirection < ActiveRecord::Base
  belongs_to :log_entry
  belongs_to :wind_direction
end
