defmodule ControlPlane.RSS do
  @moduledoc """
  The RSS context.
  """
  import Ecto.Query, warn: false
  alias ControlPlane.Repo

  alias ControlPlane.RSS.Source
  alias ControlPlane.RSS.Feed

  @doc """
  Returns the list of sources.

  ## Examples

      iex> list_sources()
      [%Source{}, ...]

  """
  def list_sources do
    Repo.all(Source)
  end

  @doc """
  Gets a single source.

  Raises `Ecto.NoResultsError` if the Source does not exist.

  ## Examples

      iex> get_source!(123)
      %Source{}

      iex> get_source!(456)
      ** (Ecto.NoResultsError)

  """
  def get_source!(id), do: Repo.get!(Source, id)

  @doc """
  Creates a source.

  ## Examples

      iex> create_source(%{field: value})
      {:ok, %Source{}}

      iex> create_source(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_source(attrs) do
    %Source{}
    |> Source.changeset(attrs)
    |> Repo.insert()
  end

  def start_worker(source) do
    Feed.Supervisor.start_worker(source)
  end

  @doc """
  Updates a source.

  ## Examples

      iex> update_source(source, %{field: new_value})
      {:ok, %Source{}}

      iex> update_source(source, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_source(%Source{} = source, attrs) do
    source
    |> Source.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a source.

  ## Examples

      iex> delete_source(source)
      {:ok, %Source{}}

      iex> delete_source(source)
      {:error, %Ecto.Changeset{}}

  """
  def delete_source(%Source{} = source) do
    Repo.delete(source)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking source changes.

  ## Examples

      iex> change_source(source)
      %Ecto.Changeset{data: %Source{}}

  """
  def change_source(%Source{} = source, attrs \\ %{}) do
    Source.changeset(source, attrs)
  end

  alias ControlPlane.RSS.ExecutionLog

  @doc """
  Returns the list of execution_logs.

  ## Examples

      iex> list_execution_logs()
      [%ExecutionLog{}, ...]

  """
  def list_execution_logs do
    Repo.all(ExecutionLog)
  end

  @doc """
  Gets a single execution_log.

  Raises `Ecto.NoResultsError` if the Execution log does not exist.

  ## Examples

      iex> get_execution_log!(123)
      %ExecutionLog{}

      iex> get_execution_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_execution_log!(id), do: Repo.get!(ExecutionLog, id)

  @doc """
  Creates a execution_log.

  ## Examples

      iex> create_execution_log(%{field: value})
      {:ok, %ExecutionLog{}}

      iex> create_execution_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_execution_log(attrs) do
    %ExecutionLog{}
    |> ExecutionLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a execution_log.

  ## Examples

      iex> update_execution_log(execution_log, %{field: new_value})
      {:ok, %ExecutionLog{}}

      iex> update_execution_log(execution_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_execution_log(%ExecutionLog{} = execution_log, attrs) do
    execution_log
    |> ExecutionLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a execution_log.

  ## Examples

      iex> delete_execution_log(execution_log)
      {:ok, %ExecutionLog{}}

      iex> delete_execution_log(execution_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_execution_log(%ExecutionLog{} = execution_log) do
    Repo.delete(execution_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking execution_log changes.

  ## Examples

      iex> change_execution_log(execution_log)
      %Ecto.Changeset{data: %ExecutionLog{}}

  """
  def change_execution_log(%ExecutionLog{} = execution_log, attrs \\ %{}) do
    ExecutionLog.changeset(execution_log, attrs)
  end
end
