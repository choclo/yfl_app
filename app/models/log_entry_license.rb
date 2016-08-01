class LogEntryLicense < ActiveRecord::Base
  belongs_to :log_entry
  belongs_to :license
end
