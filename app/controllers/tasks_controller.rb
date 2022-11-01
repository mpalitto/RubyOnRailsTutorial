class TasksController < ApplicationController
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
  puts "Matteo --> Create New Task"
  @task = Task.create(task_params)
  @tasks = Task.all
end

# private methods
private
def task_params
  params.require(:task).permit(:title, :note, :completed)
end

end
