class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
     @date = "ログイン中"
     log_in user
     params[:session][:remember_me] == "1" ? remember(user) : forget(user)
     redirect_to user
    else
     flash.now[:danger] = "認証に失敗しました。"
     render :new
    end
  end
  
  def destroy
   log_out if logged_in?
   flash[:success] = "ログアウトしました。"
   redirect_to root_url
  end
  
  def general_user_a
    user = User.find(4)
    log_in user
    redirect_to user
  end
  
  def general_user_b
    user = User.find(5)
    log_in user
    redirect_to user
  end
  
  def superior_b_user
    user = User.find(2)
    log_in user
    redirect_to user
  end
  
  def superior_a_user
    user = User.find(3)
    log_in user
    redirect_to user
  end
  
  def admin_user
    user = User.find(1)
    log_in user
    redirect_to users_path
  end
  
end
