class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  
  private
  
  #if user has a session ID we set @current_user to the user with the session user ID
def current_user
  @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
end
  
  
end
