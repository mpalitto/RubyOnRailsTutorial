class SessionsController < ApplicationController
  skip_before_action :authorize #, only: [:login, :create]

  def login
  $apts = ["apt-1", "apt-2", "apt-3", "apt-4", "apt-5", "apt-6", "apt-7"]
  puts "LOGIN"
  end
  
  def create #invocata quando user preme il bottone di LOGIN
    puts "Session CREATE"
    $user = User.find_by(email: params[:email])  #cerca utente nel DB
    if !!$user ## se utente esiste
      if $user.authenticate(params[:password]) # nel caso tutto a posto
        #puts "LOGGIN #{$user[:email]}"
        if($user.stato == "ARCHIVIATO" || $user.stato == nil || $user.stato == "NEW" ) && $user.id != 1 #Utente non ancora APPROVATO o Archiviato
          #message = "ERRORE: Utente non APPROVATO o Archiviato"
          #puts message + " USER: "+ $user.inspect
          $user = nil #esegui il logout fino a quando Utente non venga approvato
          render 'waiting4approval'
        else  #Utente può entrare... tutto a posto
          $is_admin = false           #normalmente utente non e Amministratore
          $is_gestore = false         #normalmente utente non e gestore
          if($user.id == 1) then      # a meno che sia ADMIN che lo rende anche gestore
            $user.stato = "ADMIN";
            $user.apt = "ADMIN"
            $is_admin = true
            $is_gestore = true
          end
          if($user.stato == "GESTORE") #oppure e prprio un gestore
            $user.apt = "GESTORE"
            $is_gestore = true
          end
          
          redirect_to '/home'
        end
      end
    else # Utente non esiste... diglielo!
      render 'errore'
    end
  end

  def destroy #logout
    $user = nil
    redirect_to '/login'
  end

  def waiting4approval
  end
  
  def errore
  end

  def riattiva
    user = User.find_by(email: $user[:email])  #cerca utente nel DB
    user[:stato] = "NEW" #inseriscilo nella lista di utenti in attesa di approvazione
    user.save
  end
  
end
