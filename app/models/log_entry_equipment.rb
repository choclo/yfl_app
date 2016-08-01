class LogEntryEquipment < ActiveRecord::Base
  belongs_to :log_entry
  belongs_to :equipment
end
