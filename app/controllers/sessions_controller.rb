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
      respond_to do |format|
        format.js
      end

    else
      session.delete(:user_id)
      flash[:error] = "Please check your info and try again."
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end
end
