defmodule ControlPlaneWeb.SourceLiveTest do
  use ControlPlaneWeb.ConnCase

  import Phoenix.LiveViewTest
  import ControlPlane.RSSFixtures

  @create_attrs %{url: "some url"}
  @update_attrs %{url: "some updated url"}
  @invalid_attrs %{url: nil}
  defp create_source(_) do
    source = source_fixture()

    %{source: source}
  end

  describe "Index" do
    setup [:create_source]

    test "lists all sources", %{conn: conn, source: source} do
      {:ok, _index_live, html} = live(conn, ~p"/sources")

      assert html =~ "Listing Sources"
      assert html =~ source.url
    end

    test "saves new source", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sources")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Source")
               |> render_click()
               |> follow_redirect(conn, ~p"/sources/new")

      assert render(form_live) =~ "New Source"

      assert form_live
             |> form("#source-form", source: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#source-form", source: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/sources")

      html = render(index_live)
      assert html =~ "Source created successfully"
      assert html =~ "some url"
    end

    test "updates source in listing", %{conn: conn, source: source} do
      {:ok, index_live, _html} = live(conn, ~p"/sources")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#sources-#{source.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/sources/#{source}/edit")

      assert render(form_live) =~ "Edit Source"

      assert form_live
             |> form("#source-form", source: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#source-form", source: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/sources")

      html = render(index_live)
      assert html =~ "Source updated successfully"
      assert html =~ "some updated url"
    end

    test "deletes source in listing", %{conn: conn, source: source} do
      {:ok, index_live, _html} = live(conn, ~p"/sources")

      assert index_live |> element("#sources-#{source.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sources-#{source.id}")
    end
  end

  describe "Show" do
    setup [:create_source]

    test "displays source", %{conn: conn, source: source} do
      {:ok, _show_live, html} = live(conn, ~p"/sources/#{source}")

      assert html =~ "Show Source"
      assert html =~ source.url
    end

    test "updates source and returns to show", %{conn: conn, source: source} do
      {:ok, show_live, _html} = live(conn, ~p"/sources/#{source}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/sources/#{source}/edit?return_to=show")

      assert render(form_live) =~ "Edit Source"

      assert form_live
             |> form("#source-form", source: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#source-form", source: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/sources/#{source}")

      html = render(show_live)
      assert html =~ "Source updated successfully"
      assert html =~ "some updated url"
    end
  end
end
