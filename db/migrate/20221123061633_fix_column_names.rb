class FixColumnNames < ActiveRecord::Migration[7.0]
  def change
    rename_column :tasks, :title, :oggetto
    rename_column :tasks, :completed, :urgenza
  end
end
