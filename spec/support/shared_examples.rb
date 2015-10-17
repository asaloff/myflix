shared_examples "require_sign_in" do
  it "redirects to the login page" do
    clear_current_user
    action
    expect(response).to redirect_to login_path
  end
end

shared_examples "require_admin" do
  it 'redirects to the root path' do
    set_current_user
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples "require_active" do
  it 'redirects to the root path' do
    set_inactive_user
    action
    expect(response).to redirect_to login_path
  end
end

shared_examples "send_to_my_queue" do
  it "redirects to the my queue page" do
    action
    expect(response).to redirect_to my_queue_path
  end
end

shared_examples "sets @video" do
  it "creates @video variable" do
    action
    expect(assigns(:video)).to eq(video)
  end
end

shared_examples "tokenable" do
  it "generates a token when the object is creates" do
    expect(object.token).to be_present
  end
end