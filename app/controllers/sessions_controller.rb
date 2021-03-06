class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by email: params[:email]

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path
    else
      flash["danger"] = "There was something wrong with your email address or password"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash['success'] = "You've logged out successfully"
    redirect_to root_path
  end
end