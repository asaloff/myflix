require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) {
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 9,
        :exp_year => 2019,
        :cvc => "314"
      },
    ).id
  }

  let(:declined_token) {
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 9,
        :exp_year => 2019,
        :cvc => "314"
      },
    ).id
  }

  describe StripeWrapper::Charge do
    describe '.create' do
      context "with a valid card" do
        it "makes a successful charge" do
          VCR.use_cassette "register" do
            response = StripeWrapper::Charge.create(
               :amount => 400,
               :source => valid_token,
               :description => "Charge for test@example.com"
             )
            expect(response).to be_successful
          end
        end
      end

      context "with a declined card" do
        it "makes a card declined charge" do
          VCR.use_cassette "declined" do
            response = StripeWrapper::Charge.create(
               :amount => 400,
               :source => declined_token,
               :description => "Charge for test@example.com"
             )
            expect(response).not_to be_successful
          end
        end

        it "returns an error message for declined cards" do
          VCR.use_cassette "declined error message" do
            response = StripeWrapper::Charge.create(
               :amount => 400,
               :source => declined_token,
               :description => "Charge for myflix@example.com"
             )
            expect(response.error_message).to eq "Your card was declined."
          end
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe '.create' do
      context 'with a valid card' do
        it 'creates the customer' do
          VCR.use_cassette "create_customer_valid_card" do
            sarah = Fabricate(:user)

            response = StripeWrapper::Customer.create(
              :description => "Charge for myflix@example.com",
              :source => valid_token,
              :user => sarah
            )
            expect(response).to be_successful
          end
        end
      end

      context 'with an invalid card' do
        let(:sarah) { Fabricate(:user) }

        let(:response) do
          StripeWrapper::Customer.create(
            :description => "Charge for myflix@example.com",
            :source => declined_token,
            :user => sarah
          )
        end

        it "does not create the customer" do
          VCR.use_cassette "create_customer_invalid_card" do
            expect(response).not_to be_successful
          end
        end

        it "returns the error message" do
          VCR.use_cassette "create_customer_invalid_card_message" do
            expect(response.error_message).to eq "Your card was declined."
          end
        end
      end
    end
  end
end
