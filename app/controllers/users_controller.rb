class UsersController < ApplicationController
  #protect_from_forgery with: 
  skip_before_action :verify_authenticity_token
  skip_before_action :authorize, only: [:new, :create]
  before_action :is_admin, only: [:list]
  
  def new
    @user = User.new
    #apts = Appartamenti.all    
    #@appartamenti = apts.map { |s| [s.apt, s.apt] }
    @appartamenti = $apts
  end

  def create
    myParams = {}
    myParams = user_params
    myParams[:stato] = "NEW"
    puts "Entering NEW USER #{myParams}"
    user = User.create(myParams)
    if user.save
      puts "User: #{user.id} WAS SAVED"
      AddHistory(user, 'STATO  --> NEW (registrazione nuovo utente)')
      redirect_to login_path
    else
      puts "FAIL to save NEW USER"
      apts = $apts #Appartamenti.all    
      @appartamenti = apts.map { |s| [s.apt, s.apt] }
      render 'new'
    end
  end

  def show #mostra profilo utente
    @user = User.find(params[:user_id])
  end

  def list #crea la lista degli utenti
    params[:sort] ||= 'apt'       #definisco il valore di default
    params[:direction] ||= 'asc'  #definisco il valore di default
    #puts params[:sort] 
    #puts params[:direction]
    @nuovi = User.where(stato: "NEW")  #lista utenti in attesa di approvazione
    @users = User.where.not(stato: "NEW").order(params[:sort] + ' ' + params[:direction]) #lista ordinata utenti in essere
    @stati = [['NEW','NEW'],['INQUILINO','INQUILINO'],['GESTORE','GESTORE'],['ADMIN','ADMIN'],['ARCHIVIATO','ARCHIVIATO']]
    #puts @users.inspect
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

  def ccommenti
    puts "SHOW-COMMENTI(params): #{params.inspect} #{params[:format]}"
    @user = User.find(params[:format])
  end

  def showCommenti
    #puts "SHOW-COMMENTI(params): #{params.inspect} #{params[:format]}"
    @user = User.find(params[:format])
    #AddRecord(@user, 'commenti', "balle belle")
    userComments = []
    @comments = []
    #userComments = @user.commenti.scan(/.*\n\n/m)
    if (!@user.commenti) 
      @user.commenti = ""
    end
    userComments = @user.commenti.split("\n\n") #separo un commento dall'altro in un array
    #puts "TASK-COMMENTS:"
    #puts userComments.inspect
    # per ogni commento genero l'oggetto estrapolando le varie informazioni
    userComments.each() {|c| 
      c += "\n" # inserisco un "newline" nel caso, per motivi storici, il campo del DB contenga commenti non formattati correttamente
      head = c.match(/.*\n/)[0] # ricavo l'informazione HEAD contenuta nella prima riga
      @comments.push({
        author: head.gsub(/.* by (.*)\n/,'\1'),  # estraggo l'autore da HEAD
        head: head,                      # inserisco HEAD
        body: c.gsub(head, '')           # ricavo il commento vero e proprio rimuovendo la prima riga
      })
    }
    #puts 'MP --> ' + @comments.inspect
  end
  
  def saveCommenti
    #puts "SAVE-COMMENTI(params): #{params.inspect} #{params[:DELbutton]} #{params[:userID]} #{params[:commento]} #{params[:comN]}"
    @user = User.find(params[:ID])
    #puts "SAVE-COMMENTI(user): #{@user.inspect}"
    if(params[:comN] != 'NEW') 
      #puts "SAVING MODIFIED COMMENT N. #{params[:comN]}"
      n = params[:comN].to_i
      del = params[:DELbutton]
      userComments = []
      userComments = @user.commenti.scan(/.*\n.*\n\n/)
      #puts userComments.inspect
      commenti = ""
      userComments.each_with_index() {|c, i| 
        if(i != n) 
          puts "i: " + i.to_s + "n: " + n.to_s
          commenti += c
        else
          puts "DELETING: " + c
        end
      }
      @user.commenti = commenti
    end
    #puts "COMMENTI: " 
    #puts @user.commenti
    if(del != 'DEL')
      AddRecord(@user, 'commenti', params[:commento])
    else
      @user.save
    end
    redirect_to '/utenti'
  end
  
  private
  def user_params
    params.require(:user).permit(:email, :apt, :password, :stato)
  end

  def AddRecord(rec, type, text)
  puts "ADD-RECORD:"
  puts text
  puts "AUTHOR: #{$user.email}" + $user.inspect
  if(! rec[type]) then rec[type] = "" end
  rec[type] = DateTime.now.strftime("%d/%m/%Y  %I:%M%p") + " by " + $user[:email] + "\n" + text.gsub(/\n\n+/,'\n') + "\n\n" + rec[type]
  rec.save
end

  def AddHistory(user, text)
    puts "AUTHOR: #{user[:email]}" 
    if(! user.history) then user.history = "" end
    user.history = DateTime.now.strftime("%d/%m/%Y  %I:%M%p") + " by " + user[:email] + "\n" + text + "\n\n" + user.history
    user.save
  end
  
end