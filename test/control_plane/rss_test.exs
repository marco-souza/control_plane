defmodule ControlPlane.RSSTest do
  use ControlPlane.DataCase

  alias ControlPlane.RSS

  describe "sources" do
    alias ControlPlane.RSS.Source

    import ControlPlane.RSSFixtures

    @invalid_attrs %{url: nil}

    test "list_sources/0 returns all sources" do
      source = source_fixture()
      assert RSS.list_sources() == [source]
    end

    test "get_source!/1 returns the source with given id" do
      source = source_fixture()
      assert RSS.get_source!(source.id) == source
    end

    test "create_source/1 with valid data creates a source" do
      valid_attrs = %{url: "some url"}

      assert {:ok, %Source{} = source} = RSS.create_source(valid_attrs)
      assert source.url == "some url"
    end

    test "create_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RSS.create_source(@invalid_attrs)
    end

    test "update_source/2 with valid data updates the source" do
      source = source_fixture()
      update_attrs = %{url: "some updated url"}

      assert {:ok, %Source{} = source} = RSS.update_source(source, update_attrs)
      assert source.url == "some updated url"
    end

    test "update_source/2 with invalid data returns error changeset" do
      source = source_fixture()
      assert {:error, %Ecto.Changeset{}} = RSS.update_source(source, @invalid_attrs)
      assert source == RSS.get_source!(source.id)
    end

    test "delete_source/1 deletes the source" do
      source = source_fixture()
      assert {:ok, %Source{}} = RSS.delete_source(source)
      assert_raise Ecto.NoResultsError, fn -> RSS.get_source!(source.id) end
    end

    test "change_source/1 returns a source changeset" do
      source = source_fixture()
      assert %Ecto.Changeset{} = RSS.change_source(source)
    end
  end
end
