class Survey < ApplicationRecord
  has_many :groups
  has_many :survey_questions
end
