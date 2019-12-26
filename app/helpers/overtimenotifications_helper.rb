module OvertimenotificationsHelper
  
  # ＠上長に対する[未確認]残業申請
  def overtime_notification
    @overtime_notifications = Overtimenotification.where(visited_id: current_user.id).where(checked: false)
    # 申請者ごとにグループ化
    @notificated_group = @overtime_notifications.group_by{|item| item.visitor_id}
  end
  
  # 上長が承認した残業内容
  def applicated_notification(attendance)
    if applicated_notification = @user.overtimenotifications.find_by(attendance_id: attendance.id)
      @applicated_scheduled_end_time = applicated_notification.scheduled_end_time
      @applicated_note = applicated_notification.note
    else
      return false
    end
  end
  
  def set_applicated_user(key)
    @applicated_user = User.find_by(id: key)
    @applicated_user_name = @applicated_user.name
    @applicated_user_designated_end_time = @applicated_user.designated_work_end_time
  end
  
  def set_applicated_attendance(applicated_notification)
    @applicated_attendance = Attendance.find_by(id: applicated_notification.attendance_id)
    @applicated_worked_on = @applicated_attendance.worked_on
  end
  
  def set_overtime_status(attendance)
    if applicate_overtimenotification = Overtimenotification.find_by(attendance_id: attendance.id)
      applicate_status = applicate_overtimenotification.status
      if applicate_status == "applicate"
        @applicate_status = "残業承認済"
      elsif applicate_status == "denial"
        @applicate_status = "残業否認"
      else
        @applicate_status = "残業申請中"
      end
    end
  end
  
  def overtime(applicate_notification, user)
    format("%.2f", overtime = (((applicate_notification.scheduled_end_time.floor_to(15.minutes).to_f - user.designated_work_end_time.to_f) / 60) / 60.0 ))
  end
  
  def applicated_overtime(scheduled_end_time, user)
    format("%.2f", applicated_overtime = (((scheduled_end_time.floor_to(15.minutes).to_f - user.designated_work_end_time.to_f) / 60) / 60.0 ))
  end
end
