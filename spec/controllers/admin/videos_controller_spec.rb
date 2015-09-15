require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like 'require_sign_in' do
      let(:action) { get :new }
    end

    it_behaves_like 'require_admin' do
      let(:action) { get :new }
    end
  end 
end