class SystemMessageStatus < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :message_id
end
