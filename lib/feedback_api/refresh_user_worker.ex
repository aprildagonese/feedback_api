defmodule FeedbackApi.RefreshUserWorker do
  use GenServer
  alias FeedbackApi.UsersUpdateFacade

  # 1 week in milliseconds
  @interval 604_800_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    UsersUpdateFacade.update_data
    Process.send_after(self(), :work, @interval)
    {:ok, %{last_run_at: nil}}
  end

  def handle_info(:work, _status) do
    UsersUpdateFacade.update_data
    Process.send_after(self(), :work, @interval)

    {:noreply, %{last_run_at: :calendar.local_time()}}
  end
end
