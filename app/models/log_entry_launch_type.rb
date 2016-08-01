class LogEntryLaunchType < ActiveRecord::Base
  belongs_to :log_entry
  belongs_to :launch_type  
end
