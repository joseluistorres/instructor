defmodule Instructor.Repo.Migrations.AddCoursesStudentsTable do
  use Ecto.Migration

  def change do
    create table(:courses_students, primary_key: false) do
      add :course_id, references(:courses, [column: :course_id, type: :string])
      add :user_id, references(:students, [column: :user_id, type: :string])
      add :state,   :string
    end
    create index(:courses_students, [:course_id, :user_id])
  end
end
