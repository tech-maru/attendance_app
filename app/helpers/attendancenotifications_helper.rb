module AttendancenotificationsHelper

# 申請された月勤怠インスタンス
  def set_attendance_applicate
    @app_attendance = @user.attendancenotifications.find_by(applicate_month: @first_day.to_datetime)
  end

# 申請状況
  def set_attendance_applicate_status
    if @app_attendance.present?
      @current_status = @app_attendance.status
      if @current_status == "承認"
        @text = "承認済"
        @comment = "#{set_attendance_app_visited_user}より#{@text}"
      elsif @current_status == "申請中"
        @text = "承認申請中"
        @comment = "#{set_attendance_app_visited_user}に#{@text}"
      else
        @text = "所属長承認未" 
      end
    else
      @text = "所属長承認未"
    end
  end
  
  def attendance_notification
    @attendance_notifications = Attendancenotification.where(visited_id: current_user.id).where(checked: false)
    # 申請者ごとにグループ化
    @attendance_notificated_group = @attendance_notifications.group_by{|item| item.user_id}
  end
  
  def set_visitor_user(key)
    @attendance_app_user = User.find_by(id: key).name
  end
  
  def set_attendance_app_visited_user
    if @app_attendance.present?
      @attendance_applicated_user = User.find_by(id: @app_attendance.visited_id).name
    end
  end
  
end
