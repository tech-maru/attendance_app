class Overtimenotification < ApplicationRecord
  belongs_to :attendance, optional: true, foreign_key: 'attendancce_id'
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id'
end
