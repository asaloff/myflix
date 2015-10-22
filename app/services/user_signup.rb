class UserSignup
  attr_reader :error_message

  def initialize(user, invitation)
    @user = user
    @invitation = invitation
  end

  def sign_up(stripe_token)
    if @user.valid?
      new_customer = handle_customer_registration(stripe_token)

      if new_customer.successful?
        @user.customer_token = new_customer.customer_token
        @user.save
        handle_invitation
        send_welcome_email
        @status = :success
      else
        @status = :failed
        @error_message = new_customer.error_message
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

  def handle_customer_registration(stripe_token)
    StripeWrapper::Customer.create(
      :description => "Sign up for #{@user.email}",
      :source => stripe_token,
      :user => @user,
      :plan => "myflix"
    )
  end

  def send_welcome_email
    AppMailer.delay.send_welcome(@user)
  end
end