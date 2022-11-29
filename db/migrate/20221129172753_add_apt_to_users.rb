class AddAptToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :apt, :string
  end
end
