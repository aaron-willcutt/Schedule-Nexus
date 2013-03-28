class SessionsController < ApplicationController
  def new
  end
  
  #We create a new session based on user ID if the user exists. 
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      #If remember me is checked we store a permanent cookie, 
      #if not, a temporary one.
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
    end
      redirect_to "http://localhost:3000/main/home", :notice => "Logged in"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end
  
  #We destroy the current session, delete cookie and redirect
  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => "Logged out"
  end
end
