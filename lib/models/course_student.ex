defmodule Instructor.CourseStudent do  
  use Ecto.Model

  @primary_key false
  schema "courses_students"do
    field :course_id, :string
    field :user_id,   :string
    field :state,   :string
  end
end  