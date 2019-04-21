class CreateSurveyQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_questions do |t|
      t.references :survey, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true

      t.timestamps
    end
  end
end
