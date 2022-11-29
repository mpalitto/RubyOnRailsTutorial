class SessionsController < ApplicationController
  skip_before_action :authorize #, only: [:login, :create]

  def login
    puts "LOGIN"
  end
  
  def create #invocata quando user preme il bottone di LOGIN
    puts "Session CREATE"
    @user = User.find_by(email: params[:email])  #cerca utente ne DB
    if !!@user && @user.authenticate(params[:password]) # nel caso tutto a posto
      session[:user_id]   = @user.id
      #carica la pagina "pages/home"
      redirect_to :controller => "pages", :action => "home"
    else #qualche errore ritorna alla schermata di login
      message = "ERRORE!"
      redirect_to login_path, notice: message
    end
  end

  def destroy #logout
    puts "LOGOUT: #{session[:user_id]}"
    session[:user_id] = nil
    puts "LOGOUT: #{session[:user_id]}"
    @current_user = nil
    redirect_to '/login'
    #session[:user_id] = nil
    #redirect_to root_path
    #redirect_back(fallback_location: root_path)
    #render 'login'
 end

end
