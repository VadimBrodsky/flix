class UsersController < ApplicationController
  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.not_admins
  end

  def show
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: 'Thanks for signing up!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Account successfully updated!'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to root_url, alert: 'Account successfully deleted!'
  end

  private

  def user_params
    params.require(:user)
      .permit(:name, :username, :email, :password, :password_confirmation)
  end

  def require_correct_user
    @user = User.find_by!(username: params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def set_user
    @user = User.find_by!(username: params[:id])
  end
end
