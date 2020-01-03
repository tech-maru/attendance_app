class Editnotification < ApplicationRecord
  belongs_to :user
  belongs_to :attendance
  
  validate :finished_at_is_invalid_without_a_started_at
  validate :started_at_than_finished_at_fast_if_invalid
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:after_started_at, "が必要です") if after_started_at.blank? && after_finished_at.present? && visited_id.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if after_started_at? && after_finished_at?
      errors.add(:after_started_at, "より早い退社は無効です") if after_started_at > after_finished_at && visited_id.present?
    end
  end

end
