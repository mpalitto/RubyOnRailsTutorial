class AddStatoToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :stato, :string
  end
end
