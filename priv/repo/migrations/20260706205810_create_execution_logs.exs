defmodule ControlPlane.Repo.Migrations.CreateExecutionLogs do
  use Ecto.Migration

  def change do
    create table(:execution_logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :status, :string
      add :details, :string
      add :source_id, references(:sources, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:execution_logs, [:source_id])
  end
end
