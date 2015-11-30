class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :index]

  def index
    @user = current_user
    @users = User.all
  end

  def new
    if logged_in?
      flash[:danger] = 'Cannot create a new account while logged in'
      redirect_to root_url
    else
      @user = User.new
    end
  end

  def show
    @user = current_user
    @user2 = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Account creation successful!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
    @user2 = User.find(params[:id])
  end

  def update
    if current_user.admin = true
      @user2 = User.find(params[:id])
    else
      @user2 = current_user
    end

    if @user2.update_attribute(:memberType, params[:user][:memberType])
      flash[:success] = "Profile updated"
      redirect_to @user2
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

private

  def user_params
    params.require(:user).permit(:email, :password,
                                 :password_confirmation, :memberType)
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user || current_user.admin?
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
