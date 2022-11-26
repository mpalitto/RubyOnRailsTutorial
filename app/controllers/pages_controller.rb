class PagesController < ApplicationController
  before_action :authorize

  def home
    @tasks = Task.all
    puts "Generazione vettore STATI..."
    statiPossibili = StatoRichiestaManutenzione.all
    #statiPossibili.map {|s| puts "statiPossibili: #{s.valoriPossibili}"}
    $stati = statiPossibili.map { |s| [s.valoriPossibili, s.valoriPossibili] }
    puts "stati: #{$stati}"
    #@stati.map {|s| puts "stati: #{s}"}
  end
end
