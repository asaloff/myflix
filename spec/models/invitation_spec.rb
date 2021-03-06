require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter).class_name 'User' }
  it { should validate_presence_of :invitee_name }
  it { should validate_presence_of :invitee_email }
  it { should validate_presence_of :message }
  it { should validate_presence_of :inviter }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:invitation, inviter: Fabricate(:user)) }
  end
end