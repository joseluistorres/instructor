defmodule Instructor.Repo.Migrations.AddStudentsTable do
  use Ecto.Migration

  def change do
    create table(:students, primary_key: false) do
      add :user_id, :string, primary_key: true
      add :user_name, :string
      add :state,   :string
    end
  end
end
