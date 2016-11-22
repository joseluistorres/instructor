defmodule Instructor.Repo.Migrations.AddCoursesTable do
  use Ecto.Migration

  def change do
    create table(:courses, primary_key: false) do
      add :course_id, :string, primary_key: true
      add :course_name, :string
      add :state,   :string
    end
  end
end
