class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate(params[:email_or_username], params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome back, #{user.name}!"
      redirect_to user_path(user)
    else
      flash.now[:alert] = 'Invalid email/password combination!'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'You are now signed out!'
  end
end
