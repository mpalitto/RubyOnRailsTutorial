class PagesController < ApplicationController
  before_action :authorize

  def home
    params[:sort] ||= 'created_at'       #definisco il valore di default
    params[:direction] ||= 'asc'  #definisco il valore di default
    @tasks = Task.where('apt = "' + session[:apt] + '"').order(params[:sort] + ' ' + params[:direction]) #lista ordinata
    puts "Generazione vettore STATI..."
    statiPossibili = StatoRichiestaManutenzione.all
    #statiPossibili.map {|s| puts "statiPossibili: #{s.valoriPossibili}"}
    $stati = statiPossibili.map { |s| [s.valoriPossibili, s.valoriPossibili] }
    puts "stati: #{$stati}"
    #@stati.map {|s| puts "stati: #{s}"}
  end
end
