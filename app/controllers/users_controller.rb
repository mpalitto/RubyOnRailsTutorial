class UsersController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]
  
  def new
    @user = User.new
    apts = Appartamenti.all
    @appartamenti = apts.map { |s| [s.apt, s.apt] }
  end

  def create
    puts "Entering NEW USER #{user_params}"
    @user = User.create(user_params)
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

  private
  def user_params
    params.require(:user).permit(:email, :apt, :password)
  end
end
