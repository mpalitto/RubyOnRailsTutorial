class TasksController < ApplicationController
def new
#  puts "Test Console Output"
  @task = Task.new
end

def create
  @task = Task.create(task_params)
  @tasks = Task.all
end
private
def task_params
  params.require(:task).permit(:title, :note, :completed)
end

#def clear
#  puts "Matteo --> clear"
#  @task = Task.find(params[:id])
#  @task.destroy
#  @tasks = Task.all
#end
  
#def show
#  puts "Matteo --> show"
#  @task = Task.find(params[:id])
#  @task.destroy
#  @tasks = Task.all
#end

  
#def destroy -- this method is handled in ajax by the destroy.js.erb file

end
