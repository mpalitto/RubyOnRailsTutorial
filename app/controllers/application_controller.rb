class ApplicationController < ActionController::Base
# Rescue form  invalid authentificitytoken
  rescue_from ActionController::InvalidAuthenticityToken, :with => :bad_token
  def bad_token
    flash[:warning] = "Session expired"
    redirect_to root_path
  end
  end
