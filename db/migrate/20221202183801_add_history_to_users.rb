class AddHistoryToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :history, :text
  end
end
