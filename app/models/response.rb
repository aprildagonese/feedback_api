class Response < ApplicationRecord
  belongs_to :answer
  belongs_to :response_user, class_name: 'User'
  belongs_to :target_user, class_name: 'User'
end
