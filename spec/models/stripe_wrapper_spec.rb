require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      it "makes a successful charge" do
        VCR.use_cassette "register" do
          Stripe.api_key = ENV['STRIPE_SECRET_KEY']
          token = Stripe::Token.create(
                    :card => {
                      :number => "4242424242424242",
                      :exp_month => 9,
                      :exp_year => 2016,
                      :cvc => "314"
                    },
                  ).id

          response = StripeWrapper::Charge.create(
                       :amount => 400,
                       :source => token,
                       :description => "Charge for test@example.com"
                     )
          expect(response.amount).to eq(400)
          expect(response.currency).to eq("usd")
        end
      end
    end
  end
end