class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.references :question, index: true, foreign_key: true
      t.integer :value
      t.string :description

      t.timestamps
    end
  end
end
