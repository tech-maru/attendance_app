module EditnotificationsHelper
  
  # ＠上長に対する[未確認]編集申請
  def edit_notification
    @edit_notifications = Editnotification.where(visited_id: current_user.id).where(checked: false)
    # 申請者ごとにグループ化
    @edit_notificated_group = @edit_notifications.group_by{|item| item.user_id}
  end
  
  # 上長が承認した残業内容
  def applicated_edit_notification(attendance)
    if applicated_edit_notification = @user.editnotifications.find_by(attendance_id: attendance.id)
      @applicated_before_started_at = applicated_edit_notification.before_started_at
      @applicated_before_finished_at = applicated_edit_notification.before_finished_at
      @applicated_after_started_at = applicated_edit_notification.after_started_at
      @applicated_after_finished_at = applicated_edit_notification.after_finished_at
      @applicated_edit_note = applicated_edit_notification.note
    else
      return false
    end
  end
  
  def waiting_status(editnotificaiton)
    if editnotificaiton.visited_id != nil
      editnotificaiton.update(status: "waiting")
    end
  end
  
  def set_edit_status(attendance)
    applicate_editnotifications = Editnotification.where.not(status: "")
    if applicate_editnotification = applicate_editnotifications.find_by(attendance_id: attendance.id)
      applicate_edit_status = applicate_editnotification.status
      if applicate_edit_status == "applicate"
        @applicate_status = "勤怠編集承認済"
      elsif applicate_edit_status == "denial"
        @applicate_status = "勤怠編集否認"
      else
        @applicate_status = "勤怠編集申請中"
      end
    end
  end
  
end
