defmodule FeedbackApiWeb.ResponseController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User}
  alias FeedbackApiWeb.ResponseCreateFacade

  def create(conn, params) do
    case User.authorize(params["api_key"]) do
      nil ->
        conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})

      user ->
        case ResponseCreateFacade.create(params["responses"], user) do
          :ok -> conn |> put_status(:created) |> json(%{success: "Responses have been stored"})
          :error -> conn |> put_status(:unprocessable_entity) |> json(%{error: "Invalid format"})
        end
    end
  end
end
