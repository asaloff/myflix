require 'spec_helper'

describe "deactivate account on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_16wuLrGDaDyff11epxV4BR0z",
      "object" => "event",
      "api_version" => "2015-09-08",
      "created" => 1445087039,
      "data" => {
        "object" => {
          "id" => "ch_16wuLrGDaDyff11er0CoMxme",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1445087039,
          "currency" => "usd",
          "customer" => "cus_7AtBtlG8djWnPp",
          "description" => "failed payment test",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {},
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {},
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_16wuLrGDaDyff11er0CoMxme/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_16wuKtGDaDyff11eo9hrj3wE",
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
            "customer" => "cus_7AtBtlG8djWnPp",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 10,
            "exp_year" => 2016,
            "fingerprint" => "tPfHECfcOBXVkAiG",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "statement_descriptor" => "myflix failed",
          "status" => "failed"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_7BGtKB37s4e0Wf",
      "type" => "charge.failed"
    }
  end

  it 'deactivates the user when web hook data from stripe returns charge failed', :vcr do
    sarah = Fabricate(:user, active: true, customer_token: "cus_7AtBtlG8djWnPp")
    post "/stripe_events", event_data
    expect(sarah.reload).not_to be_active
  end
end
