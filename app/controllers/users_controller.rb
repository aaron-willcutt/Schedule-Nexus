class UsersController < ApplicationController
  
  #We create a new user to be used for the @user variable
def new
  @user = User.new
end

#If the user was accepted and had their information stored we redirect to login page and provide notice
def create
  @user = User.new(params[:user])
  if @user.save
    redirect_to "http://localhost:3000/log_in", :notice => "Signed up!"
  else
    render "new"
  end
end

end
