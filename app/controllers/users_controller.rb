class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :require_active, only: [:show]
  before_action :logout, only: [:new, :new_with_invitation_token]

  def show
    @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def new_with_invitation_token
    @invitation = Invitation.find_by(token: params[:token])
    @user = User.new
    
    if @invitation
      render :new
    else
      redirect_to expired_link_path
    end
  end

  def create
    @user = User.new(user_params)
    @invitation = Invitation.find_by token: params[:invitation_token]

    result = UserSignup.new(@user, @invitation).sign_up(params[:stripeToken])

    if result.successful?
      flash['success'] = 'You have registered successfully'
      redirect_to login_path
    else
      flash.now["danger"] = result.error_message
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
