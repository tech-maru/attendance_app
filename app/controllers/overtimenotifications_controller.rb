class OvertimenotificationsController < ApplicationController
  before_action :set_attendance, only: [:new, :create]
  before_action :overtime_notification, only: :update
  
  def new
    @overtimenotification = @user.overtimenotifications.new
  end
  
  def create
    temp = Overtimenotification.find_by(attendance_id: params[:attendance_id])
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
  
  def show
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
      params.require(:overtimenotification).permit(:note, :scheduled_end_time)
    end
    
    def all_update_notification_params
      params.permit(overtimenotifications: [:status, :checked])[:overtimenotifications]
    end
end
