class PilotLicense < ActiveRecord::Base
  belongs_to :pilot
  belongs_to :license
end
