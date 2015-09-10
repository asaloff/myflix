class AppMailer < ActionMailer::Base
  def send_welcome(user)
    @user = user
    mail from: 'aaron@example.com', to: user.email, subject: 'Welcome to MyFlix!'
  end

  def send_password_reset(user)
    @user = user
    mail from: 'customersupport@myflix.com', to: user.email, subject: 'Reset your MyFlix Password'
  end

  def send_friend_signup(invitation)
    @invitation = invitation
    mail from: 'info@myflix.com', to: @invitation.invitee_email, subject: "#{@invitation.inviter.full_name} wants you to join MyFlix..."
  end
end