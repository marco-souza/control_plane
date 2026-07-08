defmodule ControlPlane.RSS.Feed.Supervisor do
  require Logger

  alias ControlPlane.RSS.Source

  use DynamicSupervisor

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    Logger.info("[feed][supervisor] init spervisor")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_worker(%Source{} = source) do
    Logger.info("[feed][supervisor] starting worker for #{source.url}")

    DynamicSupervisor.start_child(
      __MODULE__,
      {ControlPlane.RSS.Feed.Worker, source}
    )
  end
end
