# db/migrate/xxxxxxxxxx_fix_column_name.rb
class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :tasks, :note, :richiesta
  end
end