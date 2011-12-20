class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery

  before_filter :ensure_logged_in
  helper_method :current_user

  def current_user
    @current_user ||= User.get(session[:user_id])
  end

  def login(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end

  def ensure_logged_in
    redirect_to login_path if current_user.nil?
  end
end
