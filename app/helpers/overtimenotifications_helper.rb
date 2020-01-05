module OvertimenotificationsHelper
  
  # 上長ごとの[未確認]残業申請グループ
  def overtime_notification
    @overtime_notifications = Overtimenotification.where(visited_id: current_user.id).where(checked: false)
    # 申請者ごとにグループ化
    @notificated_group = @overtime_notifications.group_by{|item| item.user_id}
  end
  
  # 上長が承認した残業内容
  def applicated_overtime_detail(attendance)
    if applicated_overtime = Overtimenotification.find_by(attendance_id: attendance.id)
      if applicated_overtime.status == "承認" && applicated_overtime.checked == true
        @applicated_scheduled_end_time = applicated_overtime.scheduled_end_time
        @applicated_note = applicated_overtime.note
      else
        return false
      end
    else
      return false
    end
  end
  
  # 申請先の情報(name)
  def over_visited_user(attendance)
    if attendance.overtimenotification.present? && attendance.overtimenotification.checked != true
      @visited_user = User.find(attendance.overtimenotification.visited_id).name
    end
  end
  
  # 申請者の情報
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
      overtime_status = applicate_overtimenotification.status
        if overtime_status == "承認" && applicate_overtimenotification.checked == true
          @app_over_status = "残業承認済"
        elsif overtime_status == "否認" && applicate_overtimenotification.checked == true
          @app_over_status = "残業否認"
        else
          @app_over_status = "残業申請中"
        end
    end
  end
  
  def overtime(applicate_notification, user)
    @app_sche = applicate_notification.scheduled_end_time.floor_to(15.minutes)
    @app_sche_time = ((@app_sche.hour * 60) + @app_sche.min) / 60.0
    @user_des_end = user.designated_work_end_time
    @user_des_end_time = ((@user_des_end.hour * 60) + @user_des_end.min) / 60.0
    format("%.2f", overtime = @app_sche_time - @user_des_end_time)
  end
  
end
