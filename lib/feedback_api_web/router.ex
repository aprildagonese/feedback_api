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

    scope "/surveys", Surveys do
      get "/pending", PendingController, :index
      get "/history", HistoryController, :index
      get "/closed", ClosedController, :index
    end

    resources "/surveys", SurveyController, only: [:index, :show, :create] do
      get "/averages", Surveys.AverageController, :show
      get "/averages/student", Surveys.StudentAverageController, :show
      get "/user_averages", Surveys.UserAverageController, :show
    end

    post "/users/register", Users.RegisterController, :create
    post "/users/login", Users.LoginController, :create
    resources "/users", UsersController, only: [:create]
    resources "/students", UsersController, only: [:index]

    resources "/cohorts", CohortController, only: [:index]

    resources "/responses", ResponseController, only: [:create]
  end

  scope "/api", FeedbackApiWeb.Api, as: :api do
    pipe_through :api
    
    scope "/v2", V2, as: :v2 do
      scope "/staff", Staff, as: :staff do
        resources "/instructors", InstructorsController, only: [:index]
      end
    end
  end
end
