defmodule Instructor.Course do  
  use Ecto.Model

  @primary_key { :course_id, :string, [] }
  schema "courses" do
    field :course_name, :string
    field :state,   :string
  end
end  