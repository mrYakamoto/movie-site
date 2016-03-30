include UsersHelper

class SessionsController < ApplicationController
  def new
    if authenticated?
      redirect_to '/'
    else
      flash[:error]
    end
  end

  def create

    @user = User.find_by_username(params["username_or_email"])
    @user ||= User.find_by_email(params["username_or_email"])

    if @user && @user.authenticate(params["password_plaintext"])
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.username}"
    else
      session.delete(:user_id)
      flash[:error] = "Please check your info and try again."
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end
end
