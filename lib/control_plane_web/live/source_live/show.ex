defmodule ControlPlaneWeb.SourceLive.Show do
  use ControlPlaneWeb, :live_view

  alias ControlPlane.RSS

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Source {@source.id}
        <:subtitle>This is a source record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/sources"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/sources/#{@source}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit source
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Url">{@source.url}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Source")
     |> assign(:source, RSS.get_source!(id))}
  end
end
