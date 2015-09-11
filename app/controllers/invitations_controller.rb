class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.create(invitation_params)

    if @invitation.save
      AppMailer.delay.send_friend_signup(@invitation)
      flash["success"] = "Your invitation has been sent"
      redirect_to new_invitation_path
    else
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:invitee_name, :invitee_email, :message, :inviter_id)
  end
end