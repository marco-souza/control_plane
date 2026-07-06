defmodule ControlPlane.RSS.ExecutionLog do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "execution_logs" do
    field :status, Ecto.Enum, values: [:started, :success, :fail]
    field :details, :string, default: ""
    field :source_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(execution_log, attrs) do
    execution_log
    |> cast(attrs, [:status, :details])
    |> validate_required([:status, :details])
  end
end
