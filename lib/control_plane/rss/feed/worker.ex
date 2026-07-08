defmodule ControlPlane.RSS.Feed.Worker do
  require Logger

  use GenServer

  alias ControlPlane.RSS.Source

  def start_link(%Source{} = source) do
    Logger.info("[feed][worker] start_link", %{source_id: source.id, url: source.url})
    GenServer.start_link(__MODULE__, source)
  end

  @impl true
  def init(%Source{} = source) do
    Logger.info("[feed][worker] initialize worker: #{inspect(source)}")

    schedule_fetch()

    {:ok, source}
  end

  @impl true
  def handle_info(:fetch, %Source{} = source) do
    Logger.info("[feed][worker] TODO: fetch content for #{source.url}")

    schedule_fetch(source.interval)

    {:noreply, source}
  end

  defp schedule_fetch(interval_in_minutes \\ 0) do
    next_execution = interval_in_minutes * 60 * 1000

    Logger.info("[feed][worker] scheduling next execution: #{next_execution}")

    Process.send_after(self(), :fetch, next_execution)
  end
end
