class CreateGroupMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :group_members do |t|
      t.references :user, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true

      t.timestamps
    end
  end
end
