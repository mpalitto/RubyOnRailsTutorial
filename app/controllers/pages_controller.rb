class PagesController < ApplicationController
  def home
    @tasks = Task.all
    statiPossibili = StatoRichiestaManutenzione.all
    #statiPossibili.map {|s| puts "statiPossibili: #{s.valoriPossibili}"}
    @stati = statiPossibili.map { |s| [s.valoriPossibili, s.valoriPossibili] }
    #@stati.map {|s| puts "stati: #{s}"}
  end
end
