defmodule FeedbackApiWeb.ResponseCreateFacade do
  alias FeedbackApi.{Repo, Response}

  def create(responses, user) do
    try do
      Enum.map(responses, fn response -> create_single_response(response, user) end)
      :ok
    rescue
      _ -> :error
    end
  end

  defp create_single_response(response, user) do
    %Response{
      reviewer_id: user.id,
      recipient_id: response["member"],
      question_id: response["question"],
      answer_id: response["answer"]
    }
    |> Repo.insert!()
  end
end
