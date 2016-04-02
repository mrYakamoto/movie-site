include UsersHelper

class UsersController < ApplicationController
  before_action :check_admin_permissions, except: [:index, :show, :new, :create, :current_user_films]

  def index
    redirect_to '/' unless current_user && current_user.is_admin?
    @users = User.order(:created_at)
  end

  def show
    @date_filler = DateTime.now()
    @screenings  = []
    current_user.films.each do |film|
      film.screenings.each do |screening|
        @screenings << screening
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    redirect_to '/' unless current_user && current_user == @user
  end

  def create
    @user = User.new(user_params)
    @user.password = new_password[:password_plaintext]
    @user.errors.messages[:pass] = ["password is too short"]

    if (new_password[:password_plaintext] != new_password[:confirm_password])
      flash[:error] = "Your passwords don't match, please re-enter"
    elsif ( new_password[:password_plaintext].length > 12 )
      flash[:error] = "Password is too long"
    elsif ( new_password[:password_plaintext].length < 6 )
      flash[:error] = "Password is too short"
    elsif @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.username}"
    else
      flash[:error] = @user.errors.full_messages.first
    end

    render :template => 'sessions/create'
  end

  def current_user_films
    data = {"user" => false, "user_films" => {}}
    if current_user
      data["user"] = true
      current_user.films.each do |film|
        data["user_films"][film.id.to_s] = film.title
      end
    end

    if request.xhr?
      render :json => data
    else
      redirect '/'
    end

  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
  def new_password
    params.require(:pass).permit(:password_plaintext, :confirm_password)
  end

end