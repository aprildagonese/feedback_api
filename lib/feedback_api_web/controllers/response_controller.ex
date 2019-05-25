defmodule FeedbackApiWeb.ResponseController do
  use FeedbackApiWeb, :controller
  alias FeedbackApi.{User}

  def create(conn, params) do
    case User.authorize(params["api_key"]) do
      nil -> conn |> put_status(:unauthorized) |> json(%{error: "Invalid API Key"})
      user -> case ResponseCreateFacade.create(params) do
        {:ok, _} -> conn |> put_status(:created) |> json(%{success: "Responses have been stored"})
        {:error, _} -> conn |> put_status(:unprocessible_entity) |> json(%{error: "Bad request"})
      end
    end
  end
end
