class AuthenticationController < ApplicationController
  before_action :require_user, :require_active
end