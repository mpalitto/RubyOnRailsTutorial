class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :note
      t.string :completed

      t.timestamps
    end
  end
end
