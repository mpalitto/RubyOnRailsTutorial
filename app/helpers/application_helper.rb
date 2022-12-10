module ApplicationHelper
  #rende l'intestazione di una tabella HTML un link per ordinare la tabella in modo crescente o decrescente
  #e aggiunge una icona alla colonna cliccata che ne indica la direzione di ordinamento
  def sortable(column, title = nil)
    title ||= column.titleize
    me = (column == params[:sort]) #la colonna che è stata cliccata coincide con quella cliccata prima?
    direction = (me && params[:direction] == "asc") ? "desc" : "asc" #se coincide allora toggle la direzione, altrimenti seleziona asc

    #nella colonna cliccata inserisci l'icona a seconda della direzione
    if(me && direction == "asc")
      (link_to title, :sort => column, :direction => direction) + "   <i id='email' class='fa fa-thumbs-down'></i>".html_safe
    elsif(me && direction == "desc")
      (link_to title, :sort => column, :direction => direction) + "   <i id='email' class='fa fa-thumbs-up'></i>".html_safe
    else #altrimenti, per le altre colonne, non aggiungere l'icona
      link_to title, :sort => column, :direction => direction
    end
  end
end