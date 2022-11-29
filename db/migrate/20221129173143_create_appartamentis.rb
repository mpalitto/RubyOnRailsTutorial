class CreateAppartamentis < ActiveRecord::Migration[7.0]
  def change
    create_table :appartamentis do |t|
      t.string :apt

      t.timestamps
    end
  end
end
