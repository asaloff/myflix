class AppMailer < ActionMailer::Base
  def send_welcome(user)
    @user = user
    mail from: 'info@myflix.com', to: Rails.env.staging? ? ENV['TEST_EMAIL'] : user.email, subject: 'Welcome to MyFlix!'
  end

  def send_password_reset(user)
    @user = user
    mail from: 'info@myflix.com', to: Rails.env.staging? ? ENV['TEST_EMAIL'] : user.email, subject: 'Reset Your Myflix Password'
  end

  def send_friend_signup(invitation)
    @invitation = invitation
    mail from: 'info@myflix.com', to: Rails.env.staging? ? ENV['TEST_EMAIL'] : @invitation.invitee_email, subject: "#{@invitation.inviter.full_name} wants you to join MyFlix..."
  end
end