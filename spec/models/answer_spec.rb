require 'rails_helper'

describe Answer, type: :model do
  describe "Relationships" do
    it { should have_many :responses }
    it { should belong_to :question }
  end
end
