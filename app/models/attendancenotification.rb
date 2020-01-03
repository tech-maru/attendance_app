class Attendancenotification < ApplicationRecord
  belongs_to :user
  
  validates :visited_id, presence: true
end
