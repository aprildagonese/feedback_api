defmodule FeedbackApiWeb.Api.V2.Staff.SurveyController do
  use FeedbackApiWeb, :controller

  alias FeedbackApi.User

  def create(conn, %{"api_key" => api_key} = params) do
    case User.authorize_instructor(api_key) do
      nil ->
        conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})

      user ->
        case FeedbackApiWeb.SurveyCreateFacade.create_survey(params["survey"], user) do
          {:ok, _survey} -> conn |> put_status(:created) |> json(%{success: "Survey stored"})
          {:error, error} -> conn |> put_status(:unprocessable_entity) |> json(%{error: error})
        end
    end
  end

  def create(conn, _params) do
    conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})
  end
end
