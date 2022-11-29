
# Richiesta di Manutenzione
Utilizzo il codice del tutorial per creare una lista di richieste di manutenzione.

In particolare il FORM nella finestra **modal** dovrà essere aggiornato per includere le seguenti informazioni, così anche come dovrà essere modificato il DB.

La richiesta dovrà essere eseguita per un appartamento e quindi dovremo aggiungere alla nostra tabella TASKs l'**interno**

`bin/rails generate migration AddInternoToTasks interno:string`

il **contatto** che identifica la persona che inserisce la richiesta

`bin/rails generate migration AddContattoToTasks contatto:string`

il campo **notes** viene rinominato **richiesta** che contiene il testo con la descrizione dettagliata della richiesta
1. `bin/rails generate migration FixColumnName` che genera il file `db/migrate/xxxxxxxxxx_fix_column_name.rb`
2. edit il file
```
# db/migrate/xxxxxxxxxx_fix_column_name.rb
class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :tasks, :note, :richiesta
  end
end
```
### aggiunta di STATO nella nella LISTA delle richieste
lo **stato** della richiesta che può assumere solo alcuni valori

i valori che **stato** può assumere saranno memorizzati in una tabella "statoRichiestaManutenzione" che ha una sola colonna "valoriPossibili" in cui memorizzare i vari valori possibili.

Questo permetterà di rendere i vari stati editabili (in futuro), cioè aggiungerne di nuovi, rimuoverne di non utili, o modificicare il nome...

`bin/rails generate model statoRichiestaManutenzione valoriPossibili:string`

per inserire il **select**, dato un oggetto: [esempio](https://www.linkedin.com/pulse/create-dynamic-select-tag-your-model-based-form-ruby-rails-josh-lee)

1. aggiungo stato al DB delle richieste `bin/rails generate migration AddStatoToTasks stato:string`
2. aggiorno il DB `rake db:migrate`
3. nel partial **_task_list.html.erb** aggiungo una colonna alla tabella per mostrare lo stato
```
       <th>State</th>
        ...
       <td class="text-success">
              <%= simple_form_for task, class: 'clearfix', remote: true  do |f| %>
                <%= f.select(:stato, stati, {}, {:onchange => 'this.form.submit()', class: "form-control"}) %>
              <% end %>
         </td>
 ```
Visto che voglio dare la possibilità all'utente di cambiare lo stato dalla lista stessa...

utilizzo come valore un select a cui vado a passare le varie opzioni disponibili per lo stato nella varibile `stati`

visto che questo PARTIAL viene inizialmente chiamato dalla HOME PAGE **pages/home.html.erb**,

devo modificare quest'ultimo file per fornire gli stati possibili ` <%= render partial: 'tasks/task_list', locals: {stati: @stati, tasks: @tasks} %>`

e il controller **controllers/pages_controller.rb** deve fornire l'oggetto `@stati` nell'**action** `home`
```
class PagesController < ApplicationController
  def home
    @tasks = Task.all
    statiPossibili = StatoRichiestaManutenzione.all
    #statiPossibili.map {|s| puts "statiPossibili: #{s.valoriPossibili}"}
    @stati = statiPossibili.map { |s| [s.valoriPossibili, s.valoriPossibili] }
    #@stati.map {|s| puts "stati: #{s}"}
  end
end
```
visto che non ho ancora una UI per definire i vari **stati** (DA FARE DOPO), li posso inserire da riga di comando

dalla **Shell** di **Replit** digito `rails c` per entrare nella **console**

dalla **console** digito `StatoRichiestaManutenzione.all` che dovrebbe restituire un array vuoto `[]`

per aggiungere il nuovo valore "new" `StatoRichiestaManutenzione.create(valoriPossibili: "new")`

lo ripeto per i vari valori che ho deciso: `"Assegnata","Pianificata", "inLavorazione", "inAttesa", "inConsegna", "Completata", "nonAccettata"`

a questo punto se digito `StatoRichiestaManutenzione.all` dovrebbe restituire un array NON vuoto

NOTA: se avessi la necessita di eliminare una riga della tabella `StatoRichiestaManutenzione.find(id).destroy` dove **"id"** è l'indice(numero) che identifica la riga

ATTENZIONE!!!
La modifica sopra citata per la HOME PAGE **pages/home.html.erb** e il relativo **controller**: **controllers/pages_controller.rb** deve essere applicata a TUTTI i files 
dove il partial **_task_list.html.erb** viene richiamato: **tasks/create.js.erb** **tasks/destroy.js.erb** e il relativo **controller**: **controllers/tasks_controller.rb** nelle **actions**
interessate: `def create` e `def destroy.

Ultima cosa da assicurarsi per far funzionare il tutto è, che quando una nuova richiesta viene inserita venga anche inserito lo stato della richiesta come nuovo... questo si può realizzare facilmente inserendolo come **input nascosto** e assicurandosi che nel controller tra i paramentri ammessi ci sia ache lo **stato**

### Rimuovere la ridondanza nel codice
Il codice così ottenuto è funzionale, ma non soddisfacente. Infatti ci sono parecchie ripetizioni che normalmente si vogliono evitare per una questione di gestibilità.

Nel caso dovessi fare nel futuro dei cambiamenti, dovrei ripeterli in tutti i files in cui quel codice si trova, come successo poc'anzi.

In particolare nel codice sviluppato fino ad ora ripete diverse volte il codice per ricavare la lista degli stati permessi sia all'interno del **controllers/task_controller.rb** che nel **controllers/pages_controller.rb**.

In questo caso sarebbe opportuno farlo calcolare una volta sola e renderlo disponibile ai vari controllers. Visto che la prima pagina chiamata dell'APP è la Home... lasciamo il calcolo li dentro (**controllers/pages_controller.rb**) e lo rendiamo disponibile ad altri controllers attraverso una variabile GLOBALE che si dichiare inserendo "$" davanti al nome della variabile. Questa operazione ha permesso di rimuovere il calcolo delle opzioni disponibili in varie parti del **tasks_controller.rb**.

Inoltre, abbiamo un altra ridondanza presente nel codice: quella che richiede di aggiornare la lista delle richieste. Questo avviene ogni qualvolta aggiungiamo o rimuoviamo le richieste... in particolare questo coincide con le varie azioni trovate all'interno del **tasks_controller.rb** e cioè: **create**, **destroy**, e **clear**. Una volta che viene aggiornata la lista dal controller, viene richiamato il corrispettivo file **views/tasks/...js.erb**.

Per evitare di scrivere lo stesso script più volte (e quindi di doverlo modificare eventualmente più volte), inserisco lo script nel file **views/application/_render_task_list.js.erb** e lo richiamo all'interno degli altri scripts con `<%= render('application/render_task_list') %>`

## User Login
ref: https://medium.com/@rmeji1/creating-a-login-with-simple-auth-using-ruby-on-rails-7dd95a03cb7a

iniziamo con il DB... dalla shell: `rails g model User username:string password_digest:string`

dalla shell: `rails db:migrate`

Uso un **gem** chiamata **bcrypt**

inserisco `gem 'bcrypt'` nel **Gemfile** e quindi da shell `bundle install`

Per usare **bcrypt** in **models/User.rb** aggiungo `has_secure_password`
```
class User < ApplicationRecord
  has_secure_password
end
```
### Routes
modifico il **config/route.rb** e aggiungo
```
  root 'sessions#home'
  # User routes
  resources :users, only: [:new, :create, :edit, :update, :show, :destroy]
  # Session routes
  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  post '/logout', to: 'sessions#destroy'
```
### Controllers
`rails generate controller sessions`

il file **controllers/session_controller.rb**
```
class SessionsController < ApplicationController

  def login
    puts "LOGIN"
  end
  
  def create #invocata quando user preme il bottone di LOGIN
    puts "Session CREATE"
    @user = User.find_by(username: params[:username])  #cerca utente ne DB
    if !!@user && @user.authenticate(params[:password]) # nel caso tutto a posto
      session[:user_id]   = @user.id
      #carica la pagina "pages/home"
      redirect_to :controller => "pages", :action => "home"
    else #qualche errore ritorna alla schermata di login
      message = "ERRORE!"
      redirect_to login_path, notice: message
    end
  end

  def destroy #logout
    session[:user_id] = nil
    redirect_to '/login'
 end

end
```

è ora di creare la schermata di LOGIN
```
<div>
  <h2>Log In</h2>
  <%= form_tag '/login' do %>
    Username: <%= text_field_tag :username %>
    Password: <%= text_field_tag :password %>
    <%= submit_tag "Log In" %>
    <% end %><br>
      <%= link_to ' Nuovo Utente',  new_user_path %>
</div>
```
come definito in **routes.rb** il `'/login'` corrisponde alla pagina **session/login**

quando vine premuto il pulsante **Log In** viene richiamata la `def create` nel **session_controller.rb**

Ho anche aggiunto il link per potersi registrare nel caso non si avesse un accesso.

Per la registrazione usiamo il **Form** definito nel **view/users/new.html.erb**
```
<h1>Registrazione Nuovo Utente</h1>

<%= form_for @user do |f| %>
  <%= f.label :username %>
  <%= f.text_field :username %><br>
  <%= f.label :password %>
  <%= f.password_field :password %>
  <%= f.submit "Crea Account" %>
<% end %> 
```
Vediamo il **controllers/users_controller.rb**
```
class UsersController < ApplicationController
  def new
    @user = User.new
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
    params.require(:user).permit(:username, :password)
  end
end
```
vengono ricevuti lo **username** e la **password** usati per inserire il nuovo utente nel DB.

NOTA: vorrei che lo username coincidesse con email e che venisse fatta una verifica che fosse un fomato di email.

Inoltre prima dell'inserimento dovrei fare la ricerca se **username** esiste ed eventualmente indicare l'errore di utente già inserito... eventuale recupero???

### Integrazione con l'APP
Quando l'utente arriva al sito gli si deve chiedere di autenticarsi: nel file **routes.rb** sostituisco la root page `  root 'sessions#login'`.

Affinchè non si possa accedere alle pagine dell'APP senza autorizzazione inseriamo in **application_controller.rb`
```
  before_action :authorize
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

```
Questo eseguirà il controllo per l'accesso ad ogni pagina del sito...

Ma dobbiamo dare l'accesso alla pagina di login e di registrazione anche senza autorizzazione...

e dobbiamo aggiungere ai relativi controllers delle pagine pubbliche `skip_before_action :authorize` subito all'interno della classe.

Nel nostro caso bisgna aggiungerlo al **pages_controller.rb** e a **tasks_controller.rb**

```
class UsersController < ApplicationController
  skip_before_action :authorize, only: [:new, :create]
...
```
```
class SessionsController < ApplicationController
  skip_before_action :authorize, only: [:create, :new]
  ...
```
## Richieste per utente e appartamento
Nel DB per ora la tabella delle richieste non contiene l'autore del richiedente, ne l'appartamanto a cui è associato

In realtà ci dovrebbe essere una tabella separata per descrivere un appartamento.
Nella nuova tabella dovrei inserire: appartamento, con la lista degli inquilini, inclusi i dati di registrazione...
Per fare questo utilizzo la tabella **USERS** a vi aggiungo la colonna dell'appartamento da selezionare all'nterno di una lista precompilata, nello stesso stile di quanto fatto per lo **stato** della richiesta.

Aggiungo appartamento dell'inquilino nella tabella **users**
`bin/rails generate migration AddAptToUsers apt:string`

Creo la nuova tabella **Appartamenti** `rails generate model appartamenti apt:string`

seguito da un `rake db:migrate` per aggiornare il DB

Mi assicuro di inserire maualmente degli appartamenti nella tabella, 

1. dalla SHELL `rails c`
2. `Appartamenti.create(apt: "apt-01")`
3. `Appartamenti.create(apt: "apt-02")`
3. `Appartamenti.create(apt: "apt-03")`
3. ...

mi assicuro che siano stati inseriti `Appartamenti.all`

Inserisco l'input per la selezione dell'Appartamento nel Form per la registrazione di nuovo utente:

inserisco `<%= f.select(:apt, @appartamenti, {}, {class: "form-control"}) %>` nel **view/users/new.html.erb**

inoltre devo aggiungere la lista degli appartamenti forniti dal **users_controller.rb**, lo faccio aggiungendo
```
  def new
    @user = User.new
    apts = Appartamenti.all
    @appartamenti = apts.map { |s| [s.apt, s.apt] }
  end
```
e aggiungo APT tra i parametri permessi per la registrazione
```
  def user_params
    params.require(:user).permit(:email, :apt, :password)
  end
```

Una volta fatto il LOGIN dobbiamo tenere in una variabile di sessione anche l'appartamento associato all'utente e visto che ci siamo anche l'email

**controllers/session_controller.rb**
```
    if !!@user && @user.authenticate(params[:password]) # nel caso tutto a posto
      session[:user_id]   = @user.id
      session[:email]   = @user.email
      session[:apt]   = @user.apt
 ```

 Quando una nuova richiesta viene inserita, dobbiamo aggiungere l'autore (email) oltre che l'appartamento

 Aggiungiamo le due colonne alla tabella **Tasks** dalla SHELL
 ```
 rails generate migration AddEmailToTasks email:string
 rails generate migration AddAptToTasks apt:string
 ```
Nel **tasks_controller.rb** ai parametri del Form aggiungo quelli della sessione (email e apt)
 ```
 def create
  myP = {}
  myP = task_params
  myP[:email] = session[:email]
  myP[:apt] = session[:apt]
  puts "Matteo --> Create New Task with params: #{myP}"
  @task = Task.create(myP)
  @tasks = Task.all
end
 ```

Quando faccio la lista delle Richieste, visualizzo solo quelle relative all'appartamento in questione:
sostituisco `@tasks = Task.all` con `@tasks = Task.where('apt = "' + session[:apt] + '"')`

Inoltre vado a dare la possibilità di rimuovere la Richiesta solo all'autore e non ai co-inquilini che però possono vedere la lista di richieste completa per appartamento nel file **view/tasks/_task_list.html.erb**
```
            <td class="text-success">
              <% if(task.email == session[:email]) %>
                <%= link_to task_path(task), method: :delete, remote: true, data: {confirm: "Are you sure you want to delete task #{task.oggetto}?"} do %>  <i class="icon-remove"></i><% end %>
              <% end %>
```
# RubyOnRailsTutorial
by Prof. Palitto

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
gem 'jquery-rails'
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

Let'a add the banner for our Webapp which will appear on all the pages... 
```
<div class="row-fluid">
  <div class="span10 offset1">
    <div class="hero-unit text-center">
      <h1>
        ToDo
      </h1>
      <p>
        Welcome to the tutorial's ToDo application
      </p>
    </div>
  </div>
</div>
```

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
3. in application.js which is located under app/assets/javascript add
```
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-modal
```
before the line ```//= require_tree .```

Done. Press ```Stop``` button and then ```Run``` button to restart the application

Time to add some task functionality.

In our home action of the pages controller we will keep all of our tasks in an instance variable named @tasks:
```
def home
  @tasks = Task.all
end
```
and now we have them available to our view. We are going to show a table with all the tasks and an appropriate message if none exists. Add the following to your home.html.erb:
```
<div class="container">
  <% if @tasks.empty? %>
    <span class="text-warning">There are no tasks!</span>
  <% else %>
    <table class="table table-hover table-bordered">
      <thead>
        <tr>
          <th>Title</th>
          <th>Created at</th>
          <th>Completed</th>
        </tr>
      </thead>
      <tbody>
        <% @tasks.each do |task| %>
          <tr>
            <td>
              <strong>
                <%= task.title %>
              </strong>
            </td>
            <td class="text-info">
              <%= task.created_at %>
            </td>
            <td class="text-success">
              <%= task.completed %>
            </td>
          </tr>
        <% end %>
      </tbody>
    </table>
  <% end %>
</div>
```

Restart the application... but there are no tasks in the DB at this point... we can add a task from the Console as we did earlier...

Reload the page and... voila!

## Step 5 Routes
In order to allow users to take some actions on the TASKs, Rails offers a standardized way to handle that.

In the file ```routes.rb``` we can list the resources... in this case we can name the resources ```tasks```   

Add the following line ```resources :tasks``` in the ```routes.rb``` file.

from the Shell run ```rails routes```
```
Prefix    Verb   URI Pattern                  Controller#Action
root      GET    /                            pages#home
tasks     GET    /tasks(.:format)             tasks#index
          POST   /tasks(.:format)             tasks#create
new_task  GET    /tasks/new(.:format)         tasks#new
edit_task GET    /tasks/:id/edit(.:format)    tasks#edit
task      GET    /tasks/:id(.:format)         tasks#show
          PATCH  /tasks/:id(.:format)         tasks#update
          PUT    /tasks/:id(.:format)         tasks#update
          DELETE /tasks/:id(.:format)         tasks#destroy
```
The difference here from ```pages``` and ```tasks``` is that ```pages``` is for STATIC pages like ```home```.

```tasks``` is associated to the group of actions that can be taken on the TASKs.

NOTE: since we spelled "resources" as plural, all but some of the routes generated require ":id"... If we spelled "resource" as singular, all routes generated would not require the ":id"


In automatic the list of actions are:
```
index
create
new
edit
show
update
destroy
```

However if we are intrested in only a few of them, we can EXCLUDE some:

replace the line inserted into ```routes.rb``` with the following: ```resources :tasks,  except:  [:index]```

from the Shell run ```rails routes```
```
Prefix    Verb   URI Pattern                  Controller#Action
root      GET    /                            pages#home
tasks     POST   /tasks(.:format)             tasks#create
new_task  GET    /tasks/new(.:format)         tasks#new
edit_task GET    /tasks/:id/edit(.:format)    tasks#edit
task      GET    /tasks/:id(.:format)         tasks#show
          PATCH  /tasks/:id(.:format)         tasks#update
          PUT    /tasks/:id(.:format)         tasks#update
          DELETE /tasks/:id(.:format)         tasks#destroy
```
as you can see the action ```index``` is removed


## Step 6 Controller
At this point we will need a task Controller to address all these actions

from the Shell run ```rails generate controller tasks```

Rails creates the tasks controller (app/controllers/tasks_controller.rb)

Let's enter the code for adding a NEW taks (tasks#new action). 

In the tasks controller:
```
def new
  @task = Task.new
end
```
## Step 7 Enter Task from GUI
The new Task is stored into the ```@task``` instance variable.

The corresponding view of the new action will be in the file ```new.js.erb``` which we will create it under app/views/tasks. 

In order to get to the View ```new.js.erb``` we can add a "new" button in our banner... 

update ```application.html.erb``` with the following
```
  <body>
<div class="row-fluid">
  <div class="span10 offset1">
    <div class="hero-unit text-center">
      <h1>
        ToDo
      </h1>
      <p>
        Welcome to the tutorial's ToDo application
      </p>    <%= link_to 'New Task', new_task_path,  class:  'btn btn-primary' %>

    </div>
  </div>
</div>
<div class="modal fade" id="modal"></div>
    <%= yield %>
  </body>
  ```
By pressing the button "New Task" we will be requesting the ```new_task.html.erb``` view

update ```new_task.html.erb``` with the following

```
<div class="modal-header">
  <h1>New Task</h1>
</div>
<%= simple_form_for @task, class: 'clearfix' do |f| %>
  <div class="modal-body">
    <%= f.input :title %>
    <%= f.input :note %>
    <%= f.input :completed %>
  </div>
  <div class="modal-footer">
    <%= f.submit 'Save', class: 'btn btn-primary' %>
  </div>
<% end %>
```

## Step 8 Enter Task from GUI with DATE PICKER

Let's make it fancier

replace
```
    <%= f.submit 'Save', class: 'btn btn-primary' %>
```
with
```
<%= f.input :completed, as: :string, input_html: {class: 'datepicker'} %>
```
We will need a new gem, so add it to the end of your Gemfile:
```
gem  'bootstrap-datepicker-rails'
```
Edit application.css.scss which is under app/assets/stylesheets and add the following before line  ```*= require_tree .```

```
*=  require bootstrap-datepicker
```
Edit application.js and add the following before line ```*//= require_tree .*```

```
//= require bootstrap-datepicker
```
Now, we have to create a javascript function that will apply the datepicker behaviour of the gem to the appropriate inputs.

At the end of the ```new_task.html.erb``` add the following
```
<script>

$( document ).ready(function() {
    $('.datepicker').datepicker();
});

</script>
```
## Step 9 Create a New Task 

Since this form was created for the @task instance variable of the controller and since that ```@task``` does not exist, but it is a new one, its action (the form’s action) has automatically been resolved to the CREATE action of the controller.

Thus we need to add the ```create``` function in the TASK Controller (app/controllers/tasks_controller.rb)...

```
def create
  @task = Task.create(task_params)
  redirect_to root_path
end
private
def task_params
  params.require(:task).permit(:title, :note, :completed)
end
```
Here we defined the create action that creates the task and then redirects to the root path aka our home page. We also created the task_params private method so that we filter the params of the request in case someone tries to pass parameters that we don’t expect. We only allow values for the title, note and completed attributes of our model. There will be cases that your model will have attributes you don’t want to be set by the user and this is the way to control them.

## Step 10 Working with PARTIALs
`partial` is: a re-usable part of code (imagine it as a part of a view) which you may embed into other partials/pages/layouts etc. So, if we have a part of a view that we want to use to other places too, we usually create a partial.

From the Home Page we see the ToDo list. If we press the "New Task"  button the list will disappear and the "New Task Form" will show instead.

Once the NEW Task has been saved, in order to show the updated ToDo list, we have to re-load the Home Page...

Now we want to simply UPDATE the ToDo list on the current page, and show or hide the "New Task Form" when needed...

In order to do this we will create a new PARTIAL file ```app/views/tasks/_task_list.html.erb```

and we move the content previously entered into ```app/views/pages/home.html.erb```

```
<div class="container">
  <% if @tasks.empty? %>
    <span class="text-warning">There are no tasks!</span>
  <% else %>
    <table class="table table-hover table-bordered">
      <thead>
        <tr>
          <th>Title</th>
          <th>Created at</th>
          <th>Completed</th>
        </tr>
      </thead>
      <tbody>
        <% @tasks.each do |task| %>
          <tr>
            <td>
              <strong>
                <%= task.title %>
              </strong>
            </td>
            <td class="text-info">
              <%= task.created_at %>
            </td>
            <td class="text-success">
              <%= task.completed %>
            </td>
          </tr>
        <% end %>
      </tbody>
    </table>
  <% end %>
</div>
```
The only difference is that we have replace the instance variable ```@tasks``` with the variable ```tasks```

and now we replace the ```app/views/pages/home.html.erb``` content with
```
<div class="container" id="task-list">
  <%= render partial: 'tasks/task_list', locals: {tasks: @tasks} %>
</div>
```
As you can see we will call the Partial by passing the ```locals: {tasks: @tasks}```

Refresh your browser, you should be having your home page displayed exactly as before, nothing changed as far as user experience is concerned. 

We can use Partial for our "New Task Form"...

Partial files start with an underscore so create a file named _new.html.erb under app/views/tasks directory and add the following contents:
```
<div class="modal-header">
  <h1>New Task</h1>
</div>
<%= simple_form_for task, class: 'clearfix' do |f| %>
  <div class="modal-body">
    <%= f.input :title %>
    <%= f.input :note %>
    <%= f.input :completed, as: :string, input_html: {class: 'datepicker'} %>  </div>
  <div class="modal-footer">
    <%= f.submit 'Save', class: 'btn btn-primary' %>
  </div>
<% end %>
<script>

$( document ).ready(function() {
    $('.datepicker').datepicker();
});

</script>
```
this is going to replace the file ```new_task.html.erb``` previously created.

Since we want the form to show into a modal window, we update the ```pages/home.html.erb``` with the following code:
```
<div class="container" id="task-list">
  <%= render partial: 'tasks/task_list', locals: {tasks: @tasks} %>
</div>
<div class="modal fade" id="modal"></div>
```
where we added the last line, which is an element in which will insert the modal window.

When we press the "New Task" button, we want to run a Javascript which will insert the code into the before mentioned element...

as for now when the button is pressed, we are going to call the "new" method into the tasks_controller.rb which by default is going to call the "tasks/new.html.erb" and eventually a "tasks/new.js.erb" file, however we want to dismiss this default behaviour and, call the "tasks/new.js.erb" file only...

to do this we can specify the ```remote: true``` option in the button (found into the "application.html.erb" file)
```
<%= link_to 'New Task',  new_task_path,  class:  'btn btn-primary', remote: true  %>
```

At this point the only thing left to do is to write the jQuery script which will insert the Partial into the modal window (in the "tasks/new.js.erb"):
```
m = $('#modal');
m.html('<%= j(render partial: 'new', locals: {task: @task}) %>');
m.modal('show');
```
When the "Save" button is pressed the action "create" get called which so far all it does is to insert the new record into the DB and reload the Home Page.

However we can modify this and update the list into the page without reloading the whole page.

First thing is to modify the "_new.html.erb" and add the "remote: true" as option in the FORM declaration ```<%= simple_form_for task, class: 'clearfix', remote: true  do |f| %>``` this will prevent the call to "tasks/create.html.erb", next remove the "redirect_to" instruction from the controller and replace it with ```@tasks = Task.all``` for updating the ToDo list.
```
def create
  @task = Task.create(task_params)
  @tasks = Task.all
end
```
last we add the "create.js.erb" file which will update the list onto the page:
```
$('#task-list').html('<%= j(render partial: 'tasks/task_list', locals: {tasks: @tasks}) %>');
$('#modal').modal('hide');
```
## Step 11 deleting a ToDo

One of the routes made available is "DELETE tasks/:id(.:format) tasks#destroy"

which we can make use... it means that

in the "_task_list.html.erb" partial file, we can add a new column in the table which displays a "x" symble and when is pressed calls that route
```
<td class="text-success">
  <%= link_to task_path(task), method: :delete, remote: true, data: {confirm: "Are you sure you want to delete task #{task.title}?"} do %>  <i class="icon-remove"></i><% end %>
</td>
```
in the "task_controller" before the "private" statement
```
def destroy
  puts "Matteo --> Remove ToDo"
  Task.find(params[:id]).destroy
  @tasks = Task.all
end
```
