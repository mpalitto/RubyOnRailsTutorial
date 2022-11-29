class AddEmailToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :email, :string
  end
end
