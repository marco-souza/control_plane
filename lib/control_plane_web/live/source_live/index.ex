defmodule ControlPlaneWeb.SourceLive.Index do
  use ControlPlaneWeb, :live_view

  alias ControlPlane.RSS

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Sources
        <:actions>
          <.button variant="primary" navigate={~p"/sources/new"}>
            <.icon name="hero-plus" /> New Source
          </.button>
        </:actions>
      </.header>

      <.table
        id="sources"
        rows={@streams.sources}
        row_click={fn {_id, source} -> JS.navigate(~p"/sources/#{source}") end}
      >
        <:col :let={{_id, source}} label="Url">{source.url}</:col>
        <:col :let={{_id, source}} label="Update Interval">{source.interval} min</:col>
        <:action :let={{_id, source}}>
          <div class="sr-only">
            <.link navigate={~p"/sources/#{source}"}>Show</.link>
          </div>
          <.link navigate={~p"/sources/#{source}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, source}}>
          <.link
            phx-click={JS.push("delete", value: %{id: source.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Sources")
     |> stream(:sources, list_sources())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    source = RSS.get_source!(id)
    {:ok, _} = RSS.delete_source(source)

    {:noreply, stream_delete(socket, :sources, source)}
  end

  defp list_sources() do
    RSS.list_sources()
  end
end
