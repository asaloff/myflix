class AuthenticationController < ApplicationController
  before_action :require_user
end