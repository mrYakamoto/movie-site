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

    @user.password = params[:password_plaintext]
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      render 'new'
    end
  end


  private

  def user_params
    params.require(:user).permit(:username, :email, :password_plaintext)
  end


end