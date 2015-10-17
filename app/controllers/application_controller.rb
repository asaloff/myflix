class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def current_user
    current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash['info'] = 'Access reserved for members only. Please sign in first.'
      redirect_to login_path
    end
  end

  def require_active
    if !current_user.active
      session[:user_id] = nil
      flash["danger"] = "Your account was deactivated. Please contact customer service."
      redirect_to login_path
    end
  end
  
  def logout
    session[:user_id] = nil
  end
end
