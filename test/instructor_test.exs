defmodule InstructorTest do
  use ExUnit.Case
  doctest Instructor

  test "the process method should read the csv files" do
    assert Instructor.process == []
  end
end
