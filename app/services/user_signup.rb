class UserSignup
  attr_reader :error_message

  def initialize(user, invitation)
    @user = user
    @invitation = invitation
  end

  def sign_up(stripe_token)
    if @user.valid?
      charge = handle_registration_charge(stripe_token)

      if charge.successful?
        @user.save
        handle_invitation
        send_welcome_email
        @status = :success
      else
        @status = :failed
        @error_message = charge.error_message
      end
    else
      @status = :failed
    end
    self
  end

  def successful?
    @status == :success
  end

  private

  def handle_invitation
    if @invitation
      @user.inviter_id = @invitation.inviter_id
      @user.save
      Relationship.create(user: @user, following: @invitation.inviter)
      Relationship.create(user: @invitation.inviter, following: @user)
      @invitation.destroy
    end
  end

  def handle_registration_charge(stripe_token)
    StripeWrapper::Charge.create(
      :amount => 999,
      :source => stripe_token,
      :description => "Sign up charge for #{@user.email}"
    )
  end

  def send_welcome_email
    AppMailer.delay.send_welcome(@user)
  end
end