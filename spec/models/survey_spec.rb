require 'rails_helper'

describe Survey, type: :model do
  describe "Relationships" do
    it { should have_many :groups }
    it { should have_many :survey_questions }
  end

  describe "class methods" do
    it ".generate" do
      user1, user2, user3, user4, user5 = create_list(:user, 5)
      json = {  "survey_name": "Mod3 Terrificus",
                "groups": [ { "name": "Team1", "members": ["#{user1.id}", "#{user2.id}"] },
                            { "name": "Team2", "members": ["#{user3.id}", "#{user4.id}"] } ],
                "questions": [ { "text": "How was this person's code?",
                                 "answers": { "1": "Poor quality",
                                              "2": "Ok",
                                              "3": "Fantastic"} },
                               { "text": "How was this person's communication?",
                                 "answers": { "1": "Slow to respond",
                                              "2": "Mostly good",
                                              "3": "Amazing communication" } },
                               { "text": "Would you work with this person again?",
                                 "answers": { "1": "I would avoid it if I could",
                                              "2": "That would be ok wiht me",
                                              "3": "I would love to!" } } ],
                "message": "You've been requested to complete a feedback survey about your Terrificus project team"  }

        Survey.generate(json)

        expect(Survey.count).to eq(1)
        expect(Group.count).to eq(2)
        expect(Question.count).to eq(3)
        expect(SurveyQuestion.count).to eq(3)
        expect(Answer.count).to eq(9)
    end
  end

  describe "instance methods" do
    it "#create_groups" do
      user1, user2, user3, user4 = create_list(:user, 4)
      groups = [ { "name": "Team1", "members": ["#{user1.id}", "#{user2.id}"] },
                 { "name": "Team2", "members": ["#{user3.id}", "#{user4.id}"] } ]

      expect(Group.count).to eq(0)
      expect(GroupMember.count).to eq(0)

      survey = create(:survey)
      survey.create_groups(groups)

      expect(Group.count).to eq(2)
      expect(GroupMember.count).to eq(4)
    end

    it "#create_questions" do
      questions =  [ { "text": "How was this person's code?",
                       "answers": { "1": "Poor quality",
                                    "2": "Ok",
                                    "3": "Fantastic"} },
                     { "text": "How was this person's communication?",
                       "answers": { "1": "Slow to respond",
                                    "2": "Mostly good",
                                    "3": "Amazing communication" } },
                     { "text": "Would you work with this person again?",
                       "answers": { "1": "I would avoid it if I could",
                                    "2": "That would be ok wiht me",
                                    "3": "I would love to!" } } ]
      expect(Question.count).to eq(0)
      expect(Answer.count).to eq(0)

      survey = create(:survey)
      survey.create_questions(questions)

      expect(Question.count).to eq(3)
      expect(Answer.count).to eq(9)
    end
  end
end
