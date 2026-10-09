class CreateHikingCriteria < ActiveRecord::Migration[8.1]
  def change
    create_table :hiking_criteria do |t|
      t.string :level
      t.string :duration
      t.text :distance
      t.text :content
      t.text :system_prompt

      t.timestamps
    end
  end
end
