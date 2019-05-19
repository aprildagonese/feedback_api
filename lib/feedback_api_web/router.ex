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

    resources "/surveys", SurveysController, only: [:index, :create]
  end
end
