require 'rails_helper'

describe SurveyQuestion, type: :model do
  describe "Relationships" do
    it { should belong_to :survey }
    it { should belong_to :question }
  end
end
