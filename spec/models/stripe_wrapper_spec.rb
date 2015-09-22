require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      context "with a valid card" do
        it "makes a successful charge" do
          VCR.use_cassette "register" do
            token = Stripe::Token.create(
                      :card => {
                        :number => "4242424242424242",
                        :exp_month => 9,
                        :exp_year => 2019,
                        :cvc => "314"
                      },
                    ).id

            response = StripeWrapper::Charge.create(
                         :amount => 400,
                         :source => token,
                         :description => "Charge for test@example.com"
                       )
            expect(response).to be_successful
          end
        end
      end

      context "with a declined card" do
        it "makes a card declined charge" do
          VCR.use_cassette "declined" do
            token = Stripe::Token.create(
                      :card => {
                        :number => "4000000000000002",
                        :exp_month => 9,
                        :exp_year => 2019,
                        :cvc => "314"
                      },
                    ).id

            response = StripeWrapper::Charge.create(
                         :amount => 400,
                         :source => token,
                         :description => "Charge for test@example.com"
                       )
            expect(response).not_to be_successful
          end
        end

        it "returns an error message for declined cards" do
          VCR.use_cassette "declined error message" do
            token = Stripe::Token.create(
                      :card => {
                        :number => "4000000000000002",
                        :exp_month => 9,
                        :exp_year => 2019,
                        :cvc => "314"
                      },
                    ).id

            response = StripeWrapper::Charge.create(
                         :amount => 400,
                         :source => token,
                         :description => "Charge for test@example.com"
                       )
            expect(response.error_message).to eq "Your card was declined."
          end
        end
      end
    end
  end
end