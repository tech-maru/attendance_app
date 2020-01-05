module EditnotificationsHelper
  
  # ＠上長に対する[未確認]編集申請
  def edit_notification
    @edit_notifications = Editnotification.where(visited_id: current_user.id).where(checked: false)
    # 申請者ごとにグループ化
    @edit_notificated_group = @edit_notifications.group_by{|item| item.user_id}
  end
  
  # 上長が承認した残業内容
  def applicated_edit_notification(attendance)
    if applicated_edit_notification = @user.editnotifications.where(attendance_id: attendance.id).where(checked: true)
      @applicated_before_started_at = applicated_edit_notification.before_started_at
      @applicated_before_finished_at = applicated_edit_notification.before_finished_at
      @applicated_after_started_at = applicated_edit_notification.after_started_at
      @applicated_after_finished_at = applicated_edit_notification.after_finished_at
      @applicated_edit_note = applicated_edit_notification.note
    else
      return false
    end
  end
  
  # 申請先ユーザーの名前
  def edit_visited_user(attendance)
    if attendance.editnotification.present? 
      if attendance.editnotification.visited_id.present? && attendance.editnotification.visited_id != 0
        @edit_visited_user = User.find(attendance.editnotification.visited_id).name
      end
    end
  end
  
  def waiting_status(editnotificaiton)
    if editnotificaiton.visited_id != nil
      editnotificaiton.update(status: "申請中")
    end
  end
  
  def set_edit_status(attendance)
    applicate_editnotifications = Editnotification.where.not(status: "")
    if applicate_editnotification = applicate_editnotifications.find_by(attendance_id: attendance.id)
      applicate_edit_status = applicate_editnotification.status
      if applicate_edit_status == "承認"
        @applicate_status = "勤怠編集承認済"
      elsif applicate_edit_status == "否認"
        @applicate_status = "勤怠編集否認"
      else
        @applicate_status = "勤怠編集申請中"
      end
    end
  end
  
  def app_editapp_user(user_id)
    @visitor_user = User.find(user_id).name
  end
  
  def edit_overtime(after_finished_at, user)
    @app_edit = after_finished_at.floor_to(15.minutes)
    @app_edit_time = ((@app_edit.hour * 60) + @app_edit.min) / 60.0
    @user_des_end = user.designated_work_end_time
    @user_des_end_time = ((@user_des_end.hour * 60) + @user_des_end.min) / 60.0
    format("%.2f", @overtime = @app_edit_time - @user_des_end_time)
  end
  
end
