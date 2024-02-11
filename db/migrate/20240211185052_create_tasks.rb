class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.datetime :scheduled_at
      t.datetime :completed_at

      t.timestamps
    end
  end
end
