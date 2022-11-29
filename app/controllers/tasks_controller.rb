class TasksController < ApplicationController
  protect_from_forgery with: :null_session

def new
  puts "Matteo --> New Task Modal Window"
  @task = Task.new
end

def clear
  puts "Matteo --> Clear List"
  Task.destroy_all
end

def destroy
  puts "Matteo --> Remove ToDo"
  Task.find(params[:id]).destroy
  @tasks = Task.all
end

def create
  myP = {}
  myP = task_params
  myP[:email] = session[:email]
  myP[:apt] = session[:apt]
  puts "Matteo --> Create New Task with params: #{myP}"
  @task = Task.create(myP)
  @tasks = Task.where('apt = "' + session[:apt] + '"')
end

def update
  puts "Matteo --> Update Task with params: #{params[:id]}"
  task = Task.find(params[:id])
  task.stato = task_params[:stato]
  task.save
end

# private methods
private
def task_params
  params.require(:task).permit(:oggetto, :richiesta, :urgenza, :stato)
end

end
