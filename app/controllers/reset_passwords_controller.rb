class ResetPasswordsController < ApplicationController
  before_action :find_user

  def show
    redirect_to expired_reset_link_path if !@user
  end

  def update
    if params[:user][:password].strip == ""
      flash["danger"] = "Please input a valid password"
      redirect_to reset_password_path(@user.password_token)
    else
      @user.update(password: params[:user][:password], password_token: nil)
      redirect_to login_path
    end
  end

  private

  def find_user
    @user = User.find_by(password_token: params[:id])
  end
end