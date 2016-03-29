include UsersHelper

class UsersController < ApplicationController
  before_action :check_admin_permissions, except: [:index, :show, :new, :create]

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
    p @user

    @user.password = new_password[:password_plaintext]

    if (new_password[:password_plaintext] != new_password[:confirm_password])
      flash[:error] = "Your passwords don't match, please re-enter"
    elsif @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.username}"
    else
      flash[:error] = @user.errors.full_messages.first

    end

    render :template => 'sessions/create'

  end


  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
  def new_password
    params.require(:pass).permit(:password_plaintext, :confirm_password)
  end



end