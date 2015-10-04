require 'spec_helper'

describe UserSignup do
  describe '#sign_up' do
    after do
      ActionMailer::Base.deliveries.clear 
    end

    context 'with valid personal info and valid card' do
      let(:charge) { double(:charge, successful?: true) }

      before do
        allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user, email: 'user@example.com', full_name: 'Sarah Doe'), Fabricate(:invitation, inviter: Fabricate(:user))).sign_up('fake_stripe_token')
      end

      it 'saves the user' do
        expect(User.count).to eq(2)
      end

      context 'email sending' do
        it 'sends the email' do
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it 'sends out email to the right recipient' do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to include('user@example.com')
        end

        it 'has the right contents' do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include('Sarah Doe')
        end
      end
    end

    context "with valid personal info, valid card, and has invitation" do
      let(:sarah) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: sarah) }
      let(:charge) { double(:charge, successful?: true) }

      before do
        allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user), invitation).sign_up('fake_stripe_token')
      end

      it "sets the new user's inviter" do
        expect(User.last.inviter_id).to eq sarah.id
      end

      it "has the new user follow the inviter" do
        expect(User.last.followings).to eq [sarah]
      end

      it "has the inviter follow the new user" do
        expect(User.last.followers).to eq [sarah]
      end

      it "destroys the invitation" do
        expect(Invitation.all.size).to eq(0)
      end
    end

    context "with valid personal info and declined card" do
      let(:charge) { double(:charge, successful?: false, error_message: "Your card was declined.") }

      before do
        allow(StripeWrapper::Charge).to receive(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user), Fabricate(:invitation, inviter: Fabricate(:user))).sign_up('fake_stripe_token')
      end

      it "does not save the user" do
        expect(User.all.size).to eq(1)
      end

      it "does not send the welcome email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context 'with invalid personal info' do
      before do
        UserSignup.new(User.new(email: 'sarah@example.com'), Fabricate(:invitation, inviter: Fabricate(:user))).sign_up('fake_stripe_token')
      end

      it 'does not save the user' do
        expect(User.all.size).to eq(1)
      end

      it 'does not send out the email' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not charge the card" do
        expect(StripeWrapper::Charge).not_to receive(:create)
      end
    end
  end
end