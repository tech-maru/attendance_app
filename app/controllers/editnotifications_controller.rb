class EditnotificationsController < ApplicationController
  def new
  end
  
  def edit_app
    ActiveRecord::Base.transaction do
      editnotification_params.each do |id, edit_params|
        editnotificaiton = Editnotification.find(id)
        editnotificaiton.update_attributes!(edit_params)
      end
    end
    flash[:success] = "勤怠情報の変更申請をしました。"
    redirect_to user_url(date: params[:date].to_date.beginning_of_month)
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date].to_date.beginning_of_month)
  end
  
  private
    def editnotification_params
      params.require(:user).permit(editnotification: [:after_started_at, :after_finished_at, :note, :visited_id, :next_day])[:editnotification]
    end
end
