class Attendance < ApplicationRecord
  belongs_to :user
  has_one :overtimenotification, dependent: :destroy
  has_many :editnotofications, dependent: :destroy
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  validate :finished_at_is_invalid_without_a_started_at
  validate :started_at_than_finished_at_fast_if_invalid
  validate :update_invalid_if_before_date_todey
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退社は無効です") if started_at > finished_at
    end
  end
  
  def update_invalid_if_before_date_todey
    if Date.current > worked_on
      errors.add(:finished_at, "退社時間を入力してください") if started_at.present? && finished_at.blank?
    end
  end

end
