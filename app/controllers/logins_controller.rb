class LoginsController < ApplicationController
  skip_filter :ensure_logged_in

  def show
  end

  def create
    user = User.get_authenticated(params[:email], params[:password])

    if user
      login(user)
      redirect_to timer_path
    else
      flash[:error] = "YOU BLEW IT!!!"
      render :show
    end
  end

  def destroy
    logout
    redirect_to login_path
  end
end
