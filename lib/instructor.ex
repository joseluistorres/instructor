defmodule Instructor do
  use Application
  alias Instructor.Repo
  alias Instructor.Student
  alias Instructor.Course
  alias Instructor.CourseStudent
  alias Ecto.Changeset
  import Ecto.Query

  # this method just initialize the repo in the app
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Instructor.Repo, []),
    ]

    opts = [strategy: :one_for_one, name: Instructor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # this method will perform the read/import/validation of the records from the CSV files
  def process do
    my_list = File.ls("csv_files")
    for filename <- elem(my_list, 1) do
      table = File.read!("csv_files/" <> filename) |> ExCsv.parse! |> ExCsv.with_headings
      process_table( table.headings, table )

    end

  end

  def process_table(headers, table) when headers == ["user_id", "user_name", "state"] do
    for row <- table do
      student = Repo.get(Student, row["user_id"])

      if student == nil do
        Repo.insert!( %Student{
          user_id: row["user_id"],
          user_name: row["user_name"],
          state: row["state"]}
        )
      else
        # this will update the state record if it already exists
        student
          |> Student.changeset(%{user_name: row["user_name"], state: row["state"]})
          |> Repo.update!
      end
    end

  end

  def process_table(headers, table) when headers == ["course_id", "course_name", "state"] do

    for row <- table do
      course = Repo.get(Course, row["course_id"])

      if course == nil do
        Repo.insert!( %Course{
          course_id: row["course_id"],
          course_name: row["course_name"],
          state: row["state"]}
        )
      else
        # this will update the state record if it already exists
        Changeset.change(course)
          |> Changeset.put_change(:course_name, row["course_name"])
          |> Changeset.put_change(:state, row["state"])
          |> Repo.update!

      end

    end

  end

  def process_table(headers, table) when headers == ["course_id", "user_id", "state"] do
    for row <- table do
      course = Repo.get(Course, row["course_id"])
      student = Repo.get(Student, row["user_id"])

      if course != nil and student != nil do
        Repo.insert!( %CourseStudent{
            course_id: row["course_id"],
            user_id: row["user_id"],
            state: row["state"]}
          )

      end
    end

  end

  def process_table( _, _ ), do: :error

  def get_list_active_courses do
    courses = Repo.all(from c in Course, where: c.state == "active")
    for course <- courses do

      query = from s in Student,
        join: sc in CourseStudent, on: s.user_id == sc.user_id,
        where: sc.course_id == ^course.course_id and sc.state == "active",
        select: {s.user_name},
        distinct: s.user_name,
        order_by: s.user_name

      students = Repo.all(query)
      IO.inspect("COURSE:" <> course.course_name)
      IO.puts("-----------List of Students--------------------------")
      IO.inspect(students)
      IO.puts("-----------------------------------------------------")
    end

  end
end
