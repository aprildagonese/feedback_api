defmodule FeedbackApiWeb.Surveys.StudentAverageController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User, Survey}

  def show(conn, params) do
    case User.authorize(params["api_key"]) do
      nil ->
        conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})

      user ->
        data = %{
          average: Survey.average_for_user(params["survey_id"], user),
          survey: Survey.one(params["survey_id"])
        }

        conn
        |> render("show.json", %{average: data})
    end
  end
end
