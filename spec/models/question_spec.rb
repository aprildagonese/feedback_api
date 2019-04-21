require 'rails_helper'

describe Question, type: :model do
  describe "Relationships" do
    it { should have_many :answers }
  end
end
