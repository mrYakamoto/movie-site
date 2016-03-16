module UsersHelper
  def authenticated?
    return !session[:user_id].nil?
  end

  def current_user
    return User.find_by_id(session[:user_id]) if authenticated?
  end

  def check_admin_permissions
    if !current_user
      flash[:error] = "You must log in to complete that action."
    elsif !current_user.is_admin?
      flash[:error] = "You are not authorized to complete that action."
    end
    redirect_to new_session_url unless (current_user && current_user.is_admin?)
  end

  def check_permissions
    if !current_user
      flash[:error] = "You must log in to complete that action."
    end
    redirect_to new_session_url unless (current_user)
  end
end
