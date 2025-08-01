class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Automatically log in the user upon sign up
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Account created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Only allow a trusted parameter "white list" through
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end