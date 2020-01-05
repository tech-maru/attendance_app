class OvertimenotificationsController < ApplicationController
  before_action :set_attendance, only: [:new, :create]
  before_action :overtime_notification, only: :overtime_update
  before_action :correct_user, only: :create
  before_action :superior_user, only: :overtime_update
  
  def new
    @overtimenotification = @user.overtimenotifications.new
  end
  
  def create
    @user = User.find(params[:user_id])
    temp = Overtimenotification.find_by(attendance_id: params[:attendance_id])
    if check < 0 && params[:overtimenotification][:next_day] == "false"
      flash[:danger] = "残業申請は指定勤務時間より遅い時間を指定してください。"
      redirect_to user_url(current_user)
    else
      if temp.blank?
        @overtimenotification = @user.overtimenotifications.new(overtimenotification_params)
        @overtimenotification.status = "waiting"
        @overtimenotification.attendance_id = params[:attendance_id]
        if @overtimenotification.save
          redirect_to user_url(current_user)
        else
          redirect_to user_url(current_user)
        end
      else
        if temp.update(update_params)
          temp.update(status: "waiting", checked: "false")
          redirect_to user_url(current_user)
        else
          redirect_to user_url(current_user)
        end
      end
    end
  end
  
  def overtime_update
    all_update_notification_params.each do |id, item|
      overtimenotification = Overtimenotification.find(id)
      overtimenotification.update_attributes(item)
    end
     redirect_to user_url(current_user)
  end
  
  private
    def set_attendance
      @user = User.find_by(id: params[:user_id])
      @attendance = Attendance.find_by(id: params[:attendance_id])
    end
    
    def overtimenotification_params
      params.require(:overtimenotification).permit(:visited_id, :note, :next_day, :scheduled_end_time)
    end
    
    def update_params
      params.require(:overtimenotification).permit(:next_day, :note, :scheduled_end_time)
    end
    
    def all_update_notification_params
      params.permit(overtimenotifications: [:status, :checked])[:overtimenotifications]
    end
    
    def check
      (overtimenotification_params["scheduled_end_time(4i)"].to_i * 60 + overtimenotification_params["scheduled_end_time(5i)"].to_i) - (@user.designated_work_end_time.hour * 60 + @user.designated_work_end_time.min) 
    end
end
