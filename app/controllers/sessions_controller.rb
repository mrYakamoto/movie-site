include UsersHelper

class SessionsController < ApplicationController
  def new
    if authenticated?
      redirect_to '/'
    else
      render 'new'
    end
  end

  def create
    @user = User.find_by_username(params["username_or_email"])
    @user = User.find_by_email(params["username_or_email"]) if !@user
    if @user && @user.authenticate(params["password_plaintext"])
      session[:user_id] = @user.id
      redirect_to '/'
    else
      session.delete(:user_id)
      @error = "Please check your info and try again."
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end
end
