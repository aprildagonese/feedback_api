require 'rails_helper'

describe User, type: :model do
  describe "Relationships" do
    it { should have_many :group_members }
    it { should have_and_belong_to_many :responses }
  end
end
