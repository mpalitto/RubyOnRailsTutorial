class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize
  
  def current_user
    $user != nil
    #@current_user ||= User.find($user.id)  #User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def is_admin
    $user.stato == "ADMIN"
  end
  helper_method :is_admin

  def authorize
    puts "AUTHORIZING..."
    redirect_to '/login' unless current_user
  end

end
