require 'rails_helper'

describe GroupMember, type: :model do
  describe "Relationships" do
    it { should belong_to :user }
    it { should belong_to :group }
  end
end
