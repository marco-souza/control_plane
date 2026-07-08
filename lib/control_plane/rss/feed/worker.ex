defmodule ControlPlane.RSS.Feed.Worker do
  require Logger

  use GenServer

  alias ControlPlane.RSS.XML
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
    Logger.info("[feed][worker] fetch content for #{source.url}")

    case XML.fetch(source.url) do
      {:ok, body} ->
        case XML.valid_rss?(body) do
          true ->
            # TODO: implement XML parsing
            # TODO: add execution logs
            # TODO: create posts
            Logger.info("[feed][worker] is RSS valid")

          false ->
            Logger.info("[feed][worker] is RSS invalid")
        end

      {:error, reason} ->
        Logger.error("[feed][worker] failed to fetch #{reason}")
    end

    schedule_fetch(source.interval)

    {:noreply, source}
  end

  defp schedule_fetch(interval_in_minutes \\ 0) do
    next_execution = interval_in_minutes * 60 * 1000

    Logger.info("[feed][worker] scheduling next execution: #{next_execution}")

    Process.send_after(self(), :fetch, next_execution)
  end
end
