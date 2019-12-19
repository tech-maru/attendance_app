class AddIndexToOvertimenotificationVisitorId < ActiveRecord::Migration[5.1]
  def change
    add_index :overtimenotifications, :visitor_id
  end
end
