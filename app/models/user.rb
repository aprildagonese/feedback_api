class User < ApplicationRecord
  has_many :group_members
  has_and_belongs_to_many :responses,
                          class_name: 'User',
                          join_table: :responses,
                          foreign_key: :response_user_id,
                          association_foreign_key: :target_user_id
end
