defmodule FeedbackApi.CloseSurveyWorker do
  use GenServer
  alias FeedbackApi.Survey

  # 1 day in milliseconds
  @interval 86_400_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    if Mix.env() == :prod, do: Survey.expire_old_surveys
    Process.send_after(self(), :work, @interval)
    {:ok, %{last_run_at: nil}}
  end

  def handle_info(:work, _status) do
    Survey.expire_old_surveys
    Process.send_after(self(), :work, @interval)

    {:noreply, %{last_run_at: :calendar.local_time()}}
  end
end
