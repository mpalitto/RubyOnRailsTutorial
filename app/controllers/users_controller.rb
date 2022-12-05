class UsersController < ApplicationController
  #protect_from_forgery with: 
  skip_before_action :verify_authenticity_token
  skip_before_action :authorize, only: [:new, :create]
  before_action :is_admin, only: [:list]
  
  def new
    @user = User.new
    apts = Appartamenti.all
    @appartamenti = apts.map { |s| [s.apt, s.apt] }
  end

  def create
    myParams = {}
    myParams = user_params
    myParams[:stato] = "NEW"
    puts "Entering NEW USER #{myParams}"
    @user = User.create(myParams)
    if @user.save
      puts "User: #{@user.id} WAS SAVED"
      AddHistory(user, 'STATO  --> NEW (registrazione nuovo utente)')
      redirect_to login_path
    else
      puts "FAIL to save NEW USER"
      render "new"
    end
  end

  def show
    @user = User.find(params[:user_id])
  end

  def list
    @nuovi = User.where(stato: "NEW")
    @users = User.where.not(stato: "NEW")
    @stati = [['NEW','NEW'],['INQUILINO','INQUILINO'],['GESTORE','GESTORE'],['ADMIN','ADMIN'],['ARCHIVIATO','ARCHIVIATO']]
    puts @users.inspect
  end

  def update
    puts "Matteo --> Update User with params: #{params[:id]}"
    user = User.find(params[:id])
    AddHistory(user, 'STATO '+ user.stato + ' --> ' + user_params[:stato])
    user.stato = user_params[:stato]
    user.save
    redirect_to '/utenti'
  end

  def showHistory
    puts "SHOW-HISTORY(params): #{params.inspect} #{params[:format]}"
    user = User.find(params[:format])
    @history = user.history
  end

  def showCommenti
    puts "SHOW-COMMENTI(params): #{params.inspect} #{params[:format]}"
    @user = User.find(params[:format])
  end

  def saveCommenti
    puts "SAVE-COMMENTI(params): #{params.inspect} #{params[:userID]}"
    @user = User.find(params[:userID])
    @user.commenti = params[:commenti]
    @user.save
    redirect_to '/utenti'
  end

  private
  def user_params
    params.require(:user).permit(:email, :apt, :password, :stato)
  end

  def AddHistory(user, text)
    puts "AUTHOR: #{current_user[:email]}" 
    if(! user.history) then user.history = "" end
    user.history = DateTime.now.strftime("%d/%m/%Y  %I:%M%p") + " by " + current_user[:email] + "\n" + text + "\n\n" + user.history
    user.save
  end
  
end