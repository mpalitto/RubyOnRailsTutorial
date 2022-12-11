class PagesController < ApplicationController
  before_action :authorize

  def home
    params[:sort] ||= 'created_at'       #definisco il valore di default
    params[:direction] ||= 'asc'  #definisco il valore di default
    
#    puts "Generazione vettore STATI..."
#    statiPossibili = StatoRichiestaManutenzione.all
#    #statiPossibili.map {|s| puts "statiPossibili: #{s.valoriPossibili}"}
#    $stati = statiPossibili.map { |s| [s.valoriPossibili, s.valoriPossibili] }
#    puts "stati: #{$stati}"
    $stati = ["new", "Assegnata","Pianificata", "inLavorazione", "inAttesa", "inConsegna", "Completata", "nonAccettata"]
    if($user.stato == "ADMIN" || $user.stato == "GESTORE")
      @apts = Task.select(:apt).map(&:apt).uniq #calcola la lista degli APT presenti nelle Richieste attive
      @apts.push('tutti') #aggiungi la lista completa
      puts "APTs: " + @apts.inspect
      @tasks = Task.all.order(params[:sort] + ' ' + params[:direction]) #lista ordinata    end
    else
      @apts = nil
      @tasks = Task.where('apt = "' + $user[:apt] + '"').order(params[:sort] + ' ' + params[:direction]) #lista ordinata    end
    #@stati.map {|s| puts "stati: #{s}"}
    end
  end
end
