class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.references :answer, index: true, foreign_key: true
      t.integer :response_user_id, foreign_key: true
      t.integer :target_user_id, foreign_key: true

      t.timestamps
    end

    add_index(:responses, %i[response_user_id target_user_id], unique: true)
    add_index(:responses, %i[target_user_id response_user_id], unique: true)
  end
end
