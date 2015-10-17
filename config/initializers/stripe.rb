Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.subscribe 'charge.succeeded' do |event|
  user = User.where(customer_token: event.data.object.customer).first
  amount = event.data.object.amount
  reference_id = event.data.object.id
  Payment.create(user: user, amount: amount, reference_id: reference_id)
end

StripeEvent.subscribe 'charge.failed' do |event|
  user = User.where(customer_token: event.data.object.customer).first
  user.deactivate!
end