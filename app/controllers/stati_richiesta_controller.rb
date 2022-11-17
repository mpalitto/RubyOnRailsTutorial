class StatiRichiestaController < ApplicationController
  def new
    @stato = statoRichiestaManutenzione.new
  end
end
