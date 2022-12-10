class TasksController < ApplicationController
  protect_from_forgery with: :null_session

def new
  #puts "Matteo --> New Task Modal Window"
  @task = Task.new
end

def clear
  #puts "Matteo --> Clear List"
  Task.destroy_all
end

def destroy
  #puts "Matteo --> Remove ToDo"
  Task.find(params[:id]).destroy
  @tasks = Task.all
end

def create
  myP = {}
  myP = task_params
  myP[:email] = session[:email]
  myP[:apt] = session[:apt]
  #puts "Matteo --> Create New Task with params: #{myP}"
  @task = Task.create(myP)
  AddRecord(@task, 'history', 'STATO  --> NEW (registrazione nuova Richiesta)')
  @tasks = Task.where('apt = "' + session[:apt] + '"')
end

def update
  #puts "Matteo --> Update Task with params: #{params[:id]}"
  task = Task.find(params[:id])
  AddRecord(task, 'history', 'STATO '+ task.stato + ' --> ' + task_params[:stato])
  task.stato = task_params[:stato]
  task.save
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
    @taskComments = []
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
      @taskComments.push({
        author: head.gsub(/.* by /,''),  # estraggo l'autore da HEAD
        head: head,                      # inserisco HEAD
        body: c.gsub(head, '')           # ricavo il commento vero e proprio rimuovendo la prima riga
      })
    }
    #puts 'MP --> ' + @taskComments.inspect
  end

  def saveCommenti
    #puts "SAVE-COMMENTI(params): #{params.inspect} #{params[:DELbutton]} #{params[:taskID]} #{params[:commento]} #{params[:comN]}"
    @task = Task.find(params[:taskID])
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
  params.require(:task).permit(:oggetto, :richiesta, :urgenza, :stato)
end

def AddRecord(rec, type, text)
  puts "ADD-RECORD:"
  puts text
  puts "AUTHOR: #{$user.email}" + $user.inspect
  if(! rec[type]) then rec[type] = "" end
  rec[type] = DateTime.now.strftime("%d/%m/%Y  %I:%M%p") + " by " + $user[:email] + "\n" + text.gsub(/\n\n+/,'\n') + "\n\n" + rec[type]
  rec.save
end

end
