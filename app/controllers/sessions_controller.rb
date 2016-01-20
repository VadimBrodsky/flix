class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome back, #{user.name}!"
      redirect_to user_path(user)
    else
      flash.now[:alert] = 'Invalid email/password combination!'
      render :new
    end
  end
end
