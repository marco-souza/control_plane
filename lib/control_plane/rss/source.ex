defmodule ControlPlane.RSS.Source do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sources" do
    field :url, :string
    # minutes
    field :interval, :integer, default: 1

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(source, attrs) do
    source
    |> cast(attrs, [:url, :interval])
    |> validate_required([:url])
  end
end
