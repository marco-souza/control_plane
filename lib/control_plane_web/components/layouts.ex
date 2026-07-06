defmodule ControlPlaneWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use ControlPlaneWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://phoenix.hexdocs.pm/scopes.html)"

  attr :id, :string, default: "menu-drawer"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="drawer lg:drawer-open">
      <input id={@id} type="checkbox" class="drawer-toggle" value={true} />

      <div class="drawer-side is-drawer-close:overflow-visible">
        <label for={@id} aria-label="close sidebar" class="drawer-overlay"></label>
        <div class="flex min-h-full flex-col items-start bg-base-200 is-drawer-close:w-14 is-drawer-open:w-64 py-2">
          <ul class="menu flex">
            <li>
              <button
                class="is-drawer-close:tooltip is-drawer-close:tooltip-right btn btn-ghost px-2"
                data-tip="Acme Org."
              >
                <!-- Home icon -->
                <div class="avatar avatar-online avatar-placeholder mx-auto">
                  <div class="bg-neutral text-neutral-content size-6 rounded-full">
                    <span class="text-sm">P</span>
                  </div>
                </div>

                <span class="is-drawer-close:hidden">
                  Personal
                </span>

                <.icon
                  name="hero-chevron-down"
                  class="my-2 inline-block size-4 is-drawer-close:hidden"
                />
              </button>
            </li>
          </ul>

          <!-- Sidebar content here -->
          <ul class="menu grow w-full">
            <li>
              <button
                class="is-drawer-close:tooltip is-drawer-close:tooltip-right"
                data-tip="Homepage"
              >
                <!-- Home icon -->
                <.icon
                  name="hero-home"
                  class="my-2 inline-block size-4"
                />
                <span class="is-drawer-close:hidden">Homepage</span>
              </button>
            </li>

            <!-- List item -->
            <li>
              <button
                class="is-drawer-close:tooltip is-drawer-close:tooltip-right"
                data-tip="Settings"
              >
                <.icon
                  name="hero-wrench-screwdriver"
                  class="my-2 inline-block size-4"
                />
                <span class="is-drawer-close:hidden">Settings</span>
              </button>
            </li>

            <div class="flex-1" />

            <span class="is-drawer-close:hidden">
              <.theme_toggle />
            </span>

            <div class="divider" />

            <li>
              <label
                for={@id}
                aria-label="open sidebar"
                class="is-drawer-close:tooltip is-drawer-close:tooltip-right"
                data-tip="Expand"
              >
                <.icon
                  name="hero-chevron-double-right"
                  class="size-4 hidden is-drawer-close:inline-block"
                />
                <.icon
                  name="hero-chevron-double-left"
                  class="size-4 inline-block is-drawer-close:hidden"
                />
                <span class="is-drawer-close:hidden">Collapse</span>
              </label>
            </li>
          </ul>
        </div>
      </div>

      <div class="drawer-content">
        <!-- Page content here -->
        <div class="p-4">
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={
          show(".phx-client-error #client-error")
          |> JS.remove_attribute("hidden", to: ".phx-client-error #client-error")
        }
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={
          show(".phx-server-error #server-error")
          |> JS.remove_attribute("hidden", to: ".phx-server-error #server-error")
        }
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 [[data-theme-source=system]_&]:!left-0 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100 mx-auto" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100 mx-auto" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100 mx-auto" />
      </button>
    </div>
    """
  end
end
