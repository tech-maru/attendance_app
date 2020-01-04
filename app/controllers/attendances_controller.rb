class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :edit_one_week, :all_update, :past_log, :output]
  before_action :logged_in_user, only: [:update, :overtime, :edit_one_month, :edit_one_week]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :edit_one_week, :all_update]
  before_action :set_one_month, only: [:edit_one_month, :output]
  before_action :overtime_notification, only: :overtime_app_index
  before_action :set_editnotification, only: :edit_one_month
  before_action :edit_notification, only: :edit_app_index
  
  UPDATE_ERROR_MSG = "登録できませんでした。再登録してください。"
  
  def edit
  end
  
  def overtime
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:attendance_id])
    @attendance.create_notification_overtime(@user)
    redirect_to user_url(@user)
  end
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
    @attendances.each do |attendance|
      @editnotification = Editnotification.find_by(attendance_id: attendance.id)
    end
  end
  
  def edit_update
    edit_update_params.each do |id, item|
      if item[:checked] == "true"
        edit_notification = Editnotification.find_by(id: id)
        edit_notification.update_attributes(item)
        attendance = Attendance.find_by(id: edit_notification.attendance_id)
        attendance.update_attributes(started_at: edit_notification.after_started_at, finished_at: edit_notification.after_finished_at)
      end
    end
     redirect_to user_url(current_user)
  end
  
  def overtime_app_index
  end
  
  def edit_app_index
  end
  
  def past_log
    if params[:user].present? 
      first_day = Time.zone.local(params[:user]["result(1i)"].to_i, params[:user]["result(2i)"].to_i).beginning_of_month
      last_day = first_day.end_of_month
      @search_attendances = Attendance.where(worked_on: first_day..last_day)
      respond_to do |format|
        format.any
        format.js
      end
    else
      @search_attendances = @user.attendances.all
    end
  end
  
  def output
    respond_to do |format|
      format.html do
      end 
      format.csv do
      end
    end
  end
  
  private
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
    
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
       flash[:danger] = "アクセスできません。"
       redirect_to root_url
      end
    end
    
    def edit_update_params
      params.permit(editnotification: [:status, :checked])[:editnotification]
    end
end
