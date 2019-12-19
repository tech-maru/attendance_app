class RenameNotificationsToOvertimeNotifications < ActiveRecord::Migration[5.1]
  def change
    rename_table :notifications, :overtimenotifications
  end
  
end