class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
  end

  def create
    session[:edit] = false
    if user = User.authenticate(params[:name],params[:password])
      session[:user_id]  = user.id
      redirect_to home_url
    else
      redirect_to login_url, :alert => "Invalid user/password combination"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_url, :notice => "Logged out"
  end

end
