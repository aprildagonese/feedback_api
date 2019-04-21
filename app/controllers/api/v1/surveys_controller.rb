class Api::V1::SurveysController < ApplicationController
  def create
    survey = Survey.generate(params)
    if survey
      render status: 201, json: { result: "Survey created" }
    end
  end
end
