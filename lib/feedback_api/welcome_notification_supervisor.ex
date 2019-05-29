defmodule FeedbackApi.WelcomeNotificationSupervisor do
  def send_notification(user) do
    opts = [restart: :transient]

    user = %{
      email: user.email,
      user_name: user.name,
      message_name: "Welcome"
    }

    Task.Supervisor.start_child(
      __MODULE__,
      Services.Mailer,
      :send_welcome_notification,
      [user],
      opts
    )
  end
end
