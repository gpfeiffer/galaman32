class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
  end

  def create
    session[:edit] = false
    if user = User.authenticate(params[:name],params[:password])
      session[:user_id]  = user.id
      session[:admin] = user.admin
      session[:senior] = user.senior
      redirect_to home_url
    else
      redirect_to login_url, :alert => "Invalid user/password combination"
    end
  end

  def destroy
    session[:senior] = false
    session[:admin] = false
    session[:user_id] = nil
    redirect_to home_url, :notice => "Logged out"
  end

  def edit
    session[:edit] = true if session[:admin]
    redirect_to :back
  end

  def view
    session[:edit] = false
    redirect_to :back
  end

end
