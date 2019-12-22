class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :edit_one_week, :all_update]
  before_action :logged_in_user, only: [:update, :overtime, :edit_one_month, :edit_one_week]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :edit_one_week, :all_update]
  before_action :set_one_month, only: :edit_one_month
  before_action :set_one_week, only: :edit_one_week
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
  end
  
  def edit_one_week
  end
  
  def all_update
    debugger
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date].to_date.beginning_of_month)
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date].to_date.beginning_of_month)
  end
  
  def overtime_app_index
  end
  
  def edit_app_index
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
end
