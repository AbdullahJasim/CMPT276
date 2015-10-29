class UsersController < ApplicationController
  def new
    if logged_in?
      flash[:danger] = 'Cannot create a new account while logged in'
      redirect_to root_url
    else
      @user = User.new
    end
  end

  def show
    @user = User.find(params[:id])
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
    @user = User.find(params[:id])
  end

private

  def user_params
    params.require(:user).permit(:email, :password,
                                 :password_confirmation, :memberType)
  end
end
