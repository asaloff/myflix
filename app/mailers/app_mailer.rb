class AppMailer < ActionMailer::Base
  def send_welcome(user)
    @user = user
    if Rails.env.staging?
      mail from: 'info@myflix.com', to: ENV['TEST_EMAIL'], subject: 'Welcome to MyFlix!'
    else
      mail from: 'info@myflix.com', to: user.email, subject: 'Welcome to MyFlix!'
    end
  end

  def send_password_reset(user)
    @user = user
    if Rails.env.staging?
      mail from: 'info@myflix.com', to: ENV['TEST_EMAIL'], subject: 'Reset Your Myflix Password'
    else
    mail from: 'customersupport@myflix.com', to: user.email, subject: 'Reset your MyFlix Password'
    end
  end

  def send_friend_signup(invitation)
    @invitation = invitation
    if Rails.env.staging?
      mail from: 'info@myflix.com', to: ENV['TEST_EMAIL'], subject: "#{@invitation.inviter.full_name} wants you to join MyFlix..."
    else
      mail from: 'info@myflix.com', to: @invitation.invitee_email, subject: "#{@invitation.inviter.full_name} wants you to join MyFlix..."
    end
  end
end