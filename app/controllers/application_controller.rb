class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_user

  private

  def set_user
    if authenticated?
    cookies[:username] = current_user.username
    else
      cookies[:username] = ''
    end
  end
end
