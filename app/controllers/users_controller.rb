class UsersController < ApplicationController
  before_action :require_user, only: [:show]
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

    if @user.save
      handle_invitation
      AppMailer.send_welcome(@user).deliver
      flash['success'] = 'You have registered successfully'
      redirect_to login_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def handle_invitation
    if @invitation
      @user.inviter_id = @invitation.inviter_id
      @user.save
      Relationship.create(user: @user, following: @invitation.inviter)
      Relationship.create(user: @invitation.inviter, following: @user)
      @invitation.destroy
    end
  end
end