class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user
      user.update_column(:password_token, SecureRandom.urlsafe_base64)
      AppMailer.delay.send_password_reset(user)
      redirect_to sent_email_reset_path
    else
      flash["danger"] = params[:email].strip == '' ? "You must enter an email address" : "The email address you entered is not in our system"
      redirect_to forgot_password_path
    end
  end
end