class CreateStatoRichiestaManutenziones < ActiveRecord::Migration[7.0]
  def change
    create_table :stato_richiesta_manutenziones do |t|
      t.string :valoriPossibili

      t.timestamps
    end
  end
end
