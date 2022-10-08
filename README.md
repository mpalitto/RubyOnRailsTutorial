# RubyOnRailsTutorial
Learning RoR using Replit
## References
https://iridakos.com/programming/2013/12/07/creating-a-simple-todo-part-1

## Step 1 Create a new Project
In Replit: create a new Rails project

This is the equivalent as typing the command: ```rails new todo```

Rails will generate all the basic folders and files

## Step 2 Gemfile
Add into the Gemfile all needed gems

```
gem 'haml'
gem 'sass-rails'
gem 'bootstrap-sass', '~> 2.3.2.0'
gem 'simple_form'
```

run ```bundle install``` from the shell (install the Gems)

run ```rails importmap:install``` (this will add the app/javascript/application.js file)

press ```Run``` button

## Step 3 Database/model + running the Console
```rails generate model Task title:string note:text completed:date```

Let's use the console (similar to JS console) which allows to interact with the application from a command line

from the Shell ```rails c``` this will give access to the Console

from the Console: ```Task.count``` which will give error bc no table is found

from the Console type ```exit``` to get back to the shell

from the Shell run ```rake db:migrate RAILS_ENV=development``` which will create the table

```rails c``` to go back to the Console

From the Console ```Task.count``` which will return ```0``` since there is no data stored into the table

```Task.create(title:  'First task',  note:  'This task was created inside the rails console')``` for adding the 1st task

```Task.count``` will return ```1```

let's store the DB 1st task into a variable: ```task =  Task.first```

Let's modify the 1st task: 
```
task.title =  'First task - edited'
task.save
```

Let's verify the change: ```Task.first``` will print the task in the DB 

```Task.count``` will return ```1```

Let's Delete the task from the DB: ```task.destroy```

```Task.count``` will return ```0```

## Step 4 Home Page

The ```app/views/layouts/application.html.erb``` file is a layout meaning that you may use it to display content that you wish to be present to a lot (if not to all) of your application’s pages. Each page you create will be embedded at line 11. You may add whatever you want before & after the yield directive.

create static pages controller now, from the Shell: ```rails generate controller pages```

Add a "home action" in the generated controller pages_controller.rb which is located under app/controllers:
```
class PagesController < ApplicationController
  def home
  end
end
```

Create the corresponding (empty) home page file home.html.erb under app/views/pages directory.

Remove the comments from the routes.rb file which is located under the config directory and add the following line in order to have our home page being rendered as the root path of the application:

```root to:  'pages#home'```

In order to have the Boostrap magic enabled:
1. rename the application.css file which is located under app/assets/stylesheets to application.css.scss
2. add the following line to the bottom of the file:  ```@import  'bootstrap';```
3. in application.js which is located under app/assets/javascript add  ```//= require bootstrap```
before the line ```//= require_tree .```

Done. Press ```Stop``` button and then ```Run``` button to restart the application

Time to add some task functionality.

In our home action of the pages controller we will keep all of our tasks in an instance variable named @tasks:
```
def home
  @tasks = Task.all
end
```
and now we have them available to our view. We are going to show a table with all the tasks and an appropriate message if none exists. Add the following to your home.html.haml:
```
<div class="container">
  <% if @tasks.empty? %>
    <span class="text-warning"> There are no tasks! </span>
  <% else %>
    <table class="table table-hover table-bordered">
      <thead>
        <tr>
          <th> Title </th>
          <th> Created at </th>
          <th> Completed </th>
        </tr>
      </thead>
      <tbody>
        <% @tasks.each do |task| %>
          <tr>
            <td><strong><%= task.title %></strong> </td>
            <td class="text-info" ><%= task.created_at %> </td>
            <td class="text-success"<%= task.completed %> </td>
           </tr> 
        <% end %>
      </tbody>
    </table>
  <% end %>
</div>        


```

Restart the application... but there are no tasks in the DB at this point... we can add a task from the Console as we did earlier...

Reload the page and... voila!

## Step 5 Enter Task from GUI
