class UsersController < ApplicationController
  protect_from_forgery with: :null_session
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
    user.stato = user_params[:stato]
    user.save
    redirect_to '/utenti'
  end

  private
  def user_params
    params.require(:user).permit(:email, :apt, :password, :stato)
  end
end
