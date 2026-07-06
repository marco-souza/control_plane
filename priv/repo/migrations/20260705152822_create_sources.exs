defmodule ControlPlane.Repo.Migrations.CreateSources do
  use Ecto.Migration

  def change do
    create table(:sources, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string

      timestamps(type: :utc_datetime)
    end
  end
end
