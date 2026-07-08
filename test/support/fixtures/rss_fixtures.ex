defmodule ControlPlane.RSSFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ControlPlane.RSS` context.
  """

  @doc """
  Generate a source.
  """
  def source_fixture(attrs \\ %{}) do
    {:ok, source} =
      attrs
      |> Enum.into(%{
        url: "some url"
      })
      |> ControlPlane.RSS.create_source()

    source
  end

  @doc """
  Generate a execution_log.
  """
  def execution_log_fixture(attrs \\ %{}) do
    {:ok, execution_log} =
      attrs
      |> Enum.into(%{
        details: "some details",
        status: :started
      })
      |> ControlPlane.RSS.create_execution_log()

    execution_log
  end
end
