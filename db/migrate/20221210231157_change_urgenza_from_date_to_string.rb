class ChangeUrgenzaFromDateToString < ActiveRecord::Migration[7.0]
  def self.up
    change_table :tasks do |t|
      t.change :urgenza, :date
    end
  end
  def self.down
    change_table :tasks do |t|
      t.change :urgenza, :string
    end
  end
end
