require 'rails_helper'

describe 'Surveys API' do
  it "creates a survey" do
    json = {
            "survey_name": "Mod3 Terrificus",

            }

    post '/api/v1/surveys', params: {
                                          "location": "Denver, CO",
                                          "api_key": "jgn983hy48thw9begh98h4539h4"
                                        }

    expect(response).to be_successful

    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end
