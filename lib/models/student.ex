defmodule Instructor.Student do
  use Ecto.Model

  @primary_key { :user_id, :string, [] }
  schema "students" do
    field :user_name, :string
    field :state,   :string
  end

  @required_fields ~w(user_name state)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
