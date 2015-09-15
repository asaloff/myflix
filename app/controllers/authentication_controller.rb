class AuthenticationController < ApplicationController
  before_action :require_user

  def require_user
    if !logged_in?
      flash['info'] = 'Access reserved for members only. Please sign in first.'
      redirect_to login_path
    end
  end
end