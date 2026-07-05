defmodule ControlPlaneWeb.PageController do
  use ControlPlaneWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
