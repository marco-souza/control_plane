defmodule ControlPlaneWeb.SourceLive.Form do
  use ControlPlaneWeb, :live_view

  alias ControlPlane.RSS
  alias ControlPlane.RSS.Source

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage source records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="source-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:url]} type="text" label="Url" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Source</.button>
          <.button navigate={return_path(@return_to, @source)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    source = RSS.get_source!(id)

    socket
    |> assign(:page_title, "Edit Source")
    |> assign(:source, source)
    |> assign(:form, to_form(RSS.change_source(source)))
  end

  defp apply_action(socket, :new, _params) do
    source = %Source{}

    socket
    |> assign(:page_title, "New Source")
    |> assign(:source, source)
    |> assign(:form, to_form(RSS.change_source(source)))
  end

  @impl true
  def handle_event("validate", %{"source" => source_params}, socket) do
    changeset = RSS.change_source(socket.assigns.source, source_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"source" => source_params}, socket) do
    save_source(socket, socket.assigns.live_action, source_params)
  end

  defp save_source(socket, :edit, source_params) do
    case RSS.update_source(socket.assigns.source, source_params) do
      {:ok, source} ->
        {:noreply,
         socket
         |> put_flash(:info, "Source updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, source))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_source(socket, :new, source_params) do
    case RSS.create_source(source_params) do
      {:ok, source} ->
        {:noreply,
         socket
         |> put_flash(:info, "Source created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, source))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _source), do: ~p"/sources"
  defp return_path("show", source), do: ~p"/sources/#{source}"
end
