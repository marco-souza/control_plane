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

  describe "execution_logs" do
    alias ControlPlane.RSS.ExecutionLog

    import ControlPlane.RSSFixtures

    @invalid_attrs %{status: nil, details: nil}

    test "list_execution_logs/0 returns all execution_logs" do
      execution_log = execution_log_fixture()
      assert RSS.list_execution_logs() == [execution_log]
    end

    test "get_execution_log!/1 returns the execution_log with given id" do
      execution_log = execution_log_fixture()
      assert RSS.get_execution_log!(execution_log.id) == execution_log
    end

    test "create_execution_log/1 with valid data creates a execution_log" do
      valid_attrs = %{status: "some status", details: "some details"}

      assert {:ok, %ExecutionLog{} = execution_log} = RSS.create_execution_log(valid_attrs)
      assert execution_log.status == "some status"
      assert execution_log.details == "some details"
    end

    test "create_execution_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RSS.create_execution_log(@invalid_attrs)
    end

    test "update_execution_log/2 with valid data updates the execution_log" do
      execution_log = execution_log_fixture()
      update_attrs = %{status: "some updated status", details: "some updated details"}

      assert {:ok, %ExecutionLog{} = execution_log} = RSS.update_execution_log(execution_log, update_attrs)
      assert execution_log.status == "some updated status"
      assert execution_log.details == "some updated details"
    end

    test "update_execution_log/2 with invalid data returns error changeset" do
      execution_log = execution_log_fixture()
      assert {:error, %Ecto.Changeset{}} = RSS.update_execution_log(execution_log, @invalid_attrs)
      assert execution_log == RSS.get_execution_log!(execution_log.id)
    end

    test "delete_execution_log/1 deletes the execution_log" do
      execution_log = execution_log_fixture()
      assert {:ok, %ExecutionLog{}} = RSS.delete_execution_log(execution_log)
      assert_raise Ecto.NoResultsError, fn -> RSS.get_execution_log!(execution_log.id) end
    end

    test "change_execution_log/1 returns a execution_log changeset" do
      execution_log = execution_log_fixture()
      assert %Ecto.Changeset{} = RSS.change_execution_log(execution_log)
    end
  end
end
