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

