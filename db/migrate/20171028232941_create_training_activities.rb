class CreateTrainingActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :training_activities do |t|
      t.string :name
      t.string :notes
      t.integer :duration
      t.string :duration_notes
      t.integer :distance
      t.string :distance_notes
      t.integer :distraction
      t.string :distraction_notes
      t.timestamp :trained_at
      t.integer :training_duration
      t.references :behavior, foreign_key: true

      t.timestamps
    end
  end
end
