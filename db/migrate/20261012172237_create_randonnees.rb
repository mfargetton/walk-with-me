class CreateRandonnees < ActiveRecord::Migration[8.1]
  def change
    create_table :randonnees do |t|
      t.string :level
      t.string :duration
      t.string :distance
      t.text :content
      t.text :system_prompt

      t.timestamps
    end
  end
end
