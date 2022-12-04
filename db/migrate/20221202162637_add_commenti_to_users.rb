class AddCommentiToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :commenti, :text
  end
end
