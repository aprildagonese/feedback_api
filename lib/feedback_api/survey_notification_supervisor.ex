defmodule FeedbackApi.SurveyNotificationSupervisor do
  import Ecto.Query
  alias FeedbackApi.{Repo, User}

  def send_notifications(survey) do
    opts = [restart: :transient]

    users =
      Repo.all(
        from u in User,
          join: g in assoc(u, :groups),
          join: s in assoc(g, :survey),
          where: s.id == ^survey.id,
          where: not is_nil(u.email)
      )
      |> Enum.map(fn user ->
        %{email: user.email, user_name: user.name, message_name: survey.name}
      end)

    Task.Supervisor.start_child(
      __MODULE__,
      Services.Mailer,
      :send_survey_notifications,
      [users],
      opts
    )
  end
end
