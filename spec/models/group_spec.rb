require 'rails_helper'

describe Group, type: :model do
  describe "Relationships" do
    it { should have_many :group_members }
    it { should belong_to :survey }
  end
end
