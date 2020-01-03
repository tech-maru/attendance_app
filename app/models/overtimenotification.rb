class Overtimenotification < ApplicationRecord
  belongs_to :attendance
  belongs_to :user
end
