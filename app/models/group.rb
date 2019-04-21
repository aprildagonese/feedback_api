class Group < ApplicationRecord
  has_many :group_members
  belongs_to :survey
end
