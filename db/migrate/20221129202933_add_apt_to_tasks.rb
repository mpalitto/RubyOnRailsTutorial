class AddAptToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :apt, :string
  end
end
