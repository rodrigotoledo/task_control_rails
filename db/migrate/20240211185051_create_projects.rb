class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.datetime :completed_at

      t.timestamps
    end
  end
end
