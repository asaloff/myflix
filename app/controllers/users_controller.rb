class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:email, :password, :full_name))

    if @user.save
      flash['success'] = 'You have registered successfully'
      redirect_to login_path
    else
      render 'new'
    end
  end
end