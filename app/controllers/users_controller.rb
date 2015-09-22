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

    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :source => params[:stripeToken],
        :description => "Sign up charge for #{@user.email}"
      )
      if charge.successful?
        @user.save
        handle_invitation
        send_welcome_email
        flash['success'] = 'You have registered successfully'
        redirect_to login_path
      else
        flash["danger"] = charge.error_message
        render 'new'
      end
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

  def handle_charge

  end

  def send_welcome_email
    AppMailer.delay.send_welcome(@user)
  end
end
