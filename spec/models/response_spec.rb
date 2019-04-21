require 'rails_helper'

describe Response, type: :model do
  describe "Relationships" do
    it { should belong_to :answer }
    it { should belong_to :response_user }
    it { should belong_to :target_user }
  end
end
