class LoginsController < ApplicationController
  def show
  end

  def create
    user = User.get_authenticated(params[:email], params[:password])
    
    if user
      session[:user_id] = user.id
      redirect_to timer_path
    else
      flash[:error] = "YOU BLEW IT!!!"
      render :show
    end
  end
end
