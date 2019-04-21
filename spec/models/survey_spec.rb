require 'rails_helper'

describe Survey, type: :model do
  describe "Relationships" do
    it { should have_many :groups }
    it { should have_many :survey_questions }
  end
end
