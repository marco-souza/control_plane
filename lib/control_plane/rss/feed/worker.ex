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
    Logger.info("[feed][worker] fetch content for #{source.url}")

    normalized_url = normalize_url(source)

    case Req.get(normalized_url) do
      {:ok, %{status: 200, body: body}} ->
        Logger.info("[feed][worker] content fetched: #{inspect(body)}")

      # TODO: ensure XML is a valid rss
      # TODO: implement XML parsing
      # TODO: add posts to the DB

      {:ok, %{status: 404}} ->
        Logger.info("[feed][worker] content not found: #{source.url}")

      {:error, reason} ->
        Logger.info("[feed][worker] content not found: #{inspect(reason)}")
    end

    schedule_fetch(source.interval)

    {:noreply, source}
  end

  defp schedule_fetch(interval_in_minutes \\ 0) do
    next_execution = interval_in_minutes * 60 * 1000

    Logger.info("[feed][worker] scheduling next execution: #{next_execution}")

    Process.send_after(self(), :fetch, next_execution)
  end

  defp normalize_url(%Source{} = source) do
    case source.url do
      "http" <> _ ->
        source.url

      _ ->
        "https://#{source.url}"
    end
  end
end
