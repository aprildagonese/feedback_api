require 'rails_helper'

describe 'Surveys API' do
  it "creates a survey" do
    user1, user2, user3, user4, user5 = create_list(:user, 5)
    json = {  "survey_name": "Mod3 Terrificus",
              "groups": [ { "name": "Team1", "members": ["1", "2"] },
                          { "name": "Team2", "members": ["3", "4"] } ],
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
                                            "3": "I would love to!" } } ] }

    post '/api/v1/surveys', params: {
                                          "location": "Denver, CO",
                                          "api_key": "jgn983hy48thw9begh98h4539h4"
                                        }

    expect(response).to be_successful

    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end
