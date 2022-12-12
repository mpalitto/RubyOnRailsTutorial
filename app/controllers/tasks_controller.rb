class TasksController < ApplicationController
  protect_from_forgery with: :null_session

def new
  #puts "Matteo --> New Task Modal Window"
  @task = Task.new
  @task.email = $user.email
  @apts = $apts #Appartamenti.all.map(&:apt) #.map(|apt| apt.apt)
  puts @apts.inspect
end

def view
  @task = Task.find(params[:format])
  puts "TASK: "+ @task.inspect
end
  
def clear
  #puts "Matteo --> Clear List"
  Task.destroy_all
  redirect_to '/home'
end

def edit #Quando premuto il pulsante die EDIT dalla lista
  puts params.inspect
  #puts "Matteo --> Edit ToDo"
  @task = Task.find(params[:format])
  #@tasks = Task.all
end
  
def destroy
  #puts "Matteo --> Remove ToDo"
  Task.find(params[:id]).destroy
  if $is_gestore
    @apts = $apts
    @tasks = Task.all
  else
    @apts = []
    @tasks = Task.where('apt = "' + $user[:apt] + '"')
  end
 #redirect_to '/home'
end

def create
  puts params.inspect
  myP = {}
  myP = task_params
  myP[:email] = $user[:email]
  if(!$is_gestore)
    myP[:apt] = $user[:apt]
  end
  #puts "Matteo --> Create New Task with params: #{myP}"
  @task = Task.create(myP)
  AddRecord(@task, 'history', 'STATO  --> NEW (registrazione nuova Richiesta)')
  @tasks = Task.where('apt = "' + $user[:apt] + '"')
  @apts = nil
  if $is_gestore
    @tasks = Task.all
    @apts = Task.select(:apt).map(&:apt).uniq #calcola la lista degli APT presenti nelle Richieste attive
    @apts.push('tutti') #aggiungi la lista completa
  end
  redirect_to '/home'
end

def filter_apt
  params[:sort] ||= 'created_at'       #definisco il valore di default
  params[:direction] ||= 'asc'  #definisco il valore di default
  if(params[:apt] == 'tutti')
    @tasks = Task.all.order(params[:sort] + ' ' + params[:direction]) #lista ordinata  
  else
    @tasks = Task.where('apt = "' + params[:apt] + '"').order(params[:sort] + ' ' + params[:direction]) #lista ordinata  
  end
    @apts = Task.select(:apt).map(&:apt).uniq #calcola la lista degli APT presenti nelle Richieste attive
    @apts.push('tutti') #aggiungi la lista completa
end

def update #Richiamata quando utente modifica la Richiesta
  #puts "Matteo --> Update Task with params: #{params[:id]}"
  task = Task.find(params[:id])

  puts task_params.inspect
  puts task_params[:apt]
  puts task.apt

  #puts 'URGENZA: ' 
  #puts task.urgenza && task.urgenza.strftime("%e/%m/%Y") 
  #puts task_params[:urgenza]
  if task.urgenza != task_params[:urgenza]
    #puts "UPDATING: URGENZA"
    AddRecord(task, 'history', 'URGENZA ' + task.urgenza + ' --> ' + task_params[:urgenza])
    task.urgenza = task_params[:urgenza]
  end
  
  if(task.oggetto != task_params[:oggetto])
    AddRecord(task, 'history', 'OGGETTO '+ task.oggetto + ' --> ' + task_params[:oggetto])
    task.oggetto = task_params[:oggetto]
  end
  
  if(task.richiesta != task_params[:richiesta])
    AddRecord(task, 'history', 'RICHIESTA '+ task.richiesta + ' --> ' + task_params[:richiesta])
    task.richiesta = task_params[:richiesta]
  end
  
  if(task.stato != task_params[:stato])
    AddRecord(task, 'history', 'STATO '+ task.stato + ' --> ' + task_params[:stato])
    task.stato = task_params[:stato]
  end
  
  if !!task_params[:apt] && (task.apt != task_params[:apt]) #il gestore potrebbe cambiare l'appartamento
    AddRecord(task, 'history', 'APT '+ task.apt + ' --> ' + task_params[:apt])
    task.apt = task_params[:apt]
  end
  
  task.save
  redirect_to '/home'
end

  def history
    #puts "SHOW-HISTORY(params): #{params.inspect} #{params[:format]}"
    task = Task.find(params[:format])
    @history = task.history
  end

  def commenti
    #puts "SHOW-COMMENTI(params): #{params.inspect} #{params[:format]}"
    @task = Task.find(params[:format])
    #AddRecord(@task, 'commenti', "balle belle")
    taskComments = []
    @comments = []
    #taskComments = @task.commenti.scan(/.*\n\n/m)
    if (!@task.commenti) 
      @task.commenti = ""
    end
    taskComments = @task.commenti.split("\n\n") #separo un commento dall'altro in un array
    #puts "TASK-COMMENTS:"
    #puts taskComments.inspect
    # per ogni commento genero l'oggetto estrapolando le varie informazioni
    taskComments.each() {|c| 
      c += "\n" # inserisco un "newline" nel caso, per motivi storici, il campo del DB contenga commenti non formattati correttamente
      head = c.match(/.*\n/)[0] # ricavo l'informazione HEAD contenuta nella prima riga
      @comments.push({
        author: head.gsub(/.* by (.*)\n/,'\1'),  # estraggo l'autore da HEAD
        head: head,                      # inserisco HEAD
        body: c.gsub(head, '')           # ricavo il commento vero e proprio rimuovendo la prima riga    <% end %>    <% end %>


      })
    }
    #puts 'MP --> ' + @comments.inspect
  end

  def saveCommenti
    #puts "SAVE-COMMENTI(params): #{params.inspect} #{params[:DELbutton]} #{params[:taskID]} #{params[:commento]} #{params[:comN]}"
    @task = Task.find(params[:ID])
    #puts "SAVE-COMMENTI(task): #{@task.inspect}"
    if(params[:comN] != 'NEW') 
      #puts "SAVING MODIFIED COMMENT N. #{params[:comN]}"
      n = params[:comN].to_i
      del = params[:DELbutton]
      taskComments = []
      taskComments = @task.commenti.scan(/.*\n.*\n\n/)
      #puts taskComments.inspect
      commenti = ""
      taskComments.each_with_index() {|c, i| 
        if(i != n) 
          puts "i: " + i.to_s + "n: " + n.to_s
          commenti += c
        else
          puts "DELETING: " + c
        end
      }
      @task.commenti = commenti
    end
    #puts "COMMENTI: " 
    #puts @task.commenti
    if(del != 'DEL')
      AddRecord(@task, 'commenti', params[:commento])
    else
      @task.save
    end
    redirect_to '/home'
  end
  
# private methods
private
def task_params
  params.require(:task).permit(:oggetto, :richiesta, :urgenza, :stato, :apt)
end

def AddRecord(rec, type, text)
  puts "ADD-RECORD: " + text
  #puts text
  #puts "AUTHOR: #{$user.email}" + $user.inspect
  if(! rec[type]) then rec[type] = "" end
  rec[type] = DateTime.now.strftime("%d/%m/%Y  %I:%M%p") + " by " + $user[:email] + "\n" + text.gsub(/\n\n+/,'\n') + "\n\n" + rec[type]
  rec.save
end

end
