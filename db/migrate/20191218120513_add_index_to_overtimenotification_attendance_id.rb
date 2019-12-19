class AddIndexToOvertimenotificationAttendanceId < ActiveRecord::Migration[5.1]
  def change
    add_index :overtimenotifications, :attendance_id, unique: true
  end
end
