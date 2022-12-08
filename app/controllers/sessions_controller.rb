class SessionsController < ApplicationController
  skip_before_action :authorize #, only: [:login, :create]

  def login
    puts "LOGIN"
  end
  
  def create #invocata quando user preme il bottone di LOGIN
    puts "Session CREATE"
    $user = User.find_by(email: params[:email])  #cerca utente ne DB
    if !!$user && $user.authenticate(params[:password]) # nel caso tutto a posto
      session[:email] = $user.email
      puts "LOGGIN #{session[:email]}"
      session[:ruolo] = $user.stato
      if($user.stato == "ARCHIVIATO" || $user.stato == nil || $user.stato == "NEW" )
        message = "ERRORE: Utente non APPROVATO o Archiviato"
        puts message + " USER: "+ $user.inspect
        #redirect_to login_path, notice: message #dovrebbe andare chiedere se richiedere ad admin di ri-approvare le credenziali
        #render js:  "m = $('#modal'); m.html('<%= j(render partial: 'waiting4approval') %>'); m.modal('show');" 
        render 'waiting4approval'
      else
        session[:user_id] = $user.id
        if($user.id == 1) then
          session[:ruolo] = "ADMIN"
          $user.stato = "ADMIN";
        end
        session[:apt] = $user.apt
        #carica la pagina "pages/home"
        puts "CARICO HOME-PAGE"
        #redirect_to :controller => "pages", :action => "home"
        redirect_to '/home'
      end
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

  def waiting4approval
       #render js:  "m = $('#modal'); m.html('<%= j(render partial: 'waiting4approval') %>'); m.modal('show');" 
  end

  def riattiva
    user = User.find_by(email: session[:email])  #cerca utente nel DB
    user[:stato] = "NEW"
    user.save
  end
  
end
