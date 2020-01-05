class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include OvertimenotificationsHelper
  include EditnotificationsHelper
  include AttendancesHelper
  include AttendancenotificationsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  def set_user
    @user = User.find(params[:id])
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

# ページの閲覧権限
  def correct_user
    unless current_user?(@user) || current_user.admin? || current_user.superior?
      flash[:danger] = "不正なログインです。"
      redirect_to(root_url)
    end
  end
    
  def admin_user
    unless current_user.admin?
      flash[:danger] = "アクセスできません。"
      redirect_to root_url
    end
  end
  
  def superior_user
    unless current_user.superior? || current_user.admin?
      flash[:danger] = "不正なログインです。"
      redirect_to(root_url)
    end
  end
    
  
  def cannot_edit_admin_info
    @admin_users = User.where(admin: true)
    @admin_users.each do |user|
      if user.id == @user.id
        flash[:danger] = "アクセスできません"
        redirect_to root_url
      end
    end
  end
    
  
  def today_working
    @attendances = Attendance.where(worked_on: Date.current, finished_at: nil)
    @today_working_attendances = @attendances.where.not(started_at: nil)
    @user_id = @today_working_attendances.pluck(:user_id)
    @users = User.where(id: @user_id)
  end
  
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    
    unless one_month.count == @attendances.count
      ActiveRecord::Base.transaction do
        one_month.each do |day|
          @user.attendances.create!(worked_on: day)
        end
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
  
  def set_editnotification
    ActiveRecord::Base.transaction do
      @attendances.each do |attendance|
        if attendance.editnotification.blank?
          attendance.create_editnotification(
                                      user_id: @user.id,
                                      attendance_id: attendance.id,
                                      before_started_at: attendance.started_at, 
                                      before_finished_at: attendance.finished_at,
                                      visited_id: false,
                                      checked: false,
                                      status: ""
                                      )
        end
      end
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
  
end
