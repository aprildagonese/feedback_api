class User < ApplicationRecord
  has_many :group_members
end
