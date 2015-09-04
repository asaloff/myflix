class AppMailer < ActionMailer::Base
  def send_welcome(user)
    @user = user
    mail from: 'aaron@example.com', to: user.email, subject: 'Welcome to MyFlix!'
  end
end