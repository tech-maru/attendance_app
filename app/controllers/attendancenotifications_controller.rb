class AttendancenotificationsController < ApplicationController
  before_action :attendance_notification, only: :index
  before_action :set_user, only: :new
  before_action :correct_user, only: :new
  before_action :superior_user, only: :update
  
  def new
    @user = User.find_by(id: params[:id])
    @attendancenotification = @user.attendancenotifications.new(visited_id: params[:user][:attendancenotifications][:visited_id])
    @attendancenotification.applicate_month = params[:user][:attendancenotifications][:date].to_datetime
    @attendancenotification.status = "申請中"
    @attendancenotification.checked = false
    if @attendancenotification.save
      redirect_to user_url(date: params[:user][:attendancenotifications][:date].to_date)
    else
      flash[:danger] = "所属長を選択して再申請してください。"
      redirect_to user_url(date: params[:user][:attendancenotifications][:date].to_date)
    end
  end
  
  def update
    ActiveRecord::Base.transaction do
      attendancenotification_params.each do |id, item|
        attendancenotification = Attendancenotification.find(id)
        attendancenotification.update_attributes!(item)
      end
    end
    redirect_to user_url
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to user_url    
  end
  
  private
   def attendancenotification_params
     params.permit(attendancenotifications: [:status, :checked])[:attendancenotifications]
   end
end
