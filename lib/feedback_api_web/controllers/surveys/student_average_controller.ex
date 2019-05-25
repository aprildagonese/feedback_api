defmodule FeedbackApiWeb.Surveys.StudentAverageController do
  use FeedbackApiWeb, :controller

  def show(conn, params) do
    case User.authorize(params["api_key"]) do
      nil -> conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})
    end
  end

end
