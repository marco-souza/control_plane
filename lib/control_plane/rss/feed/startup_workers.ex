defmodule ControlPlane.RSS.Feed.StartupWorkers do
  require Logger

  use GenServer

  alias ControlPlane.RSS

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Logger.info("[feed] initialize persisted workers")

    startup_source_collectors()

    {:ok, []}
  end

  defp startup_source_collectors() do
    sources = RSS.list_sources()

    Logger.info("[feed] sources: #{inspect(sources)}")

    Enum.each(sources, fn source ->
      case RSS.Feed.Supervisor.start_worker(source) do
        {:ok, _pid} ->
          :ok

        {:error, reasons} ->
          Logger.error("[feed] failed to start worker for #{source.url}: #{inspect(reasons)}")

        :ignore ->
          Logger.warning("[feed] worker ignored for #{source.url}")
      end
    end)

    :ok
  end
end
