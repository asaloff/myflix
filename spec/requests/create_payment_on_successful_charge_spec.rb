require 'spec_helper'

describe "create payment on successful charge" do
  let(:event_data) do
    {
      "id" => "evt_16wKKXGDaDyff11eUBEdsNyw",
      "object" => "event",
      "api_version" => "2015-09-08",
      "created" => 1444948573,
      "data" => {
        "object" => {
          "id" => "ch_16wKKXGDaDyff11eHhBM9rww",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => "txn_16wKKXGDaDyff11eAeW8FNrO",
          "captured" => true,
          "created" => 1444948573,
          "currency" => "usd",
          "customer" => "cus_7AffusXYRIpeEo",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {},
          "invoice" => "in_16wKKXGDaDyff11emkUPXy6G",
          "livemode" => false,
          "metadata" => {},
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_16wKKXGDaDyff11eHhBM9rww/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_16wKKVGDaDyff11exw1NqvIl",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_7AffusXYRIpeEo",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 10,
            "exp_year" => 2017,
            "fingerprint" => "7CzkmxOcRfxLYEh4",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "statement_descriptor" => nil,
          "status" => "succeeded"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_7AffqToWsztInU",
      "type" => "charge.succeeded"
    }
  end

  it "creates a payment with the webhook form stripe for charge succeeded", :vcr do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1) 
  end

  it "creates the payment associated with the user", :vcr do
    sarah = Fabricate(:user, customer_token: "cus_7AffusXYRIpeEo")
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(sarah)
  end

  it "creates the payment with the amount", :vcr do
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with the reference ID", :vcr do
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq("ch_16wKKXGDaDyff11eHhBM9rww")
  end
end
