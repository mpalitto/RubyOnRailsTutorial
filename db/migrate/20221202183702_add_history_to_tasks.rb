class AddHistoryToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :history, :text
  end
end
