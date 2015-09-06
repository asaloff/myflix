class AppMailer < ActionMailer::Base
  def send_welcome(user)
    @user = user
    mail from: 'aaron@example.com', to: user.email, subject: 'Welcome to MyFlix!'
  end

  def send_password_reset(user)
    @user = user
    mail from: 'customersupport@myflix.com', to: user.email, subject: 'Reset your MyFlix Password'
  end
end