defmodule FeedbackApiWeb.Router do
  use FeedbackApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FeedbackApiWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", FeedbackApiWeb do
    pipe_through :api

    resources "/surveys", SurveyController, only: [:index, :create] do
      get "/averages", Surveys.AverageController, :show
      get "/user_averages", Surveys.UserAverageController, :show
    end

    scope "/surveys", FeedbackApiWeb do
      get "/pending_surveys", Surveys.PendingSurveysController, :index
    end

    resources "/users", UsersController, only: [:index, :create]
    resources "/cohorts", CohortController, only: [:index]
  end
end
