defmodule ControlPlane.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ControlPlaneWeb.Telemetry,
      ControlPlane.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:control_plane, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:control_plane, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ControlPlane.PubSub},
      # Start a worker by calling: ControlPlane.Worker.start_link(arg)
      # {ControlPlane.Worker, arg},
      # Start to serve requests, typically the last entry
      ControlPlaneWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ControlPlane.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ControlPlaneWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") == nil
  end
end
