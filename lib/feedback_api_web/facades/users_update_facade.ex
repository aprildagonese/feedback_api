defmodule FeedbackApiWeb.UsersUpdateFacade do
  alias FeedbackApi.{User, Cohort, Repo}
  import Ecto.Query
  import Services.Rooster

  def update_student_data do
    try do
      update_cohorts()
      update_students()
    rescue
      e -> "Something went wrong."
    end
  end

  def update_cohorts do
    cohorts = Services.Rooster.cohorts
    Enum.map(cohorts, fn cohort ->
      refresh_cohort(cohort)
    end)
  end

  def update_students do
    students = Services.Rooster.students
    Enum.map(students, fn student ->
      refresh_student(student)
    end)
  end

  def refresh_cohort(cohort) do
    name = cohort["attributes"]["name"]
    status = cohort["attributes"]["status"]
    result = case Cohort.get(Cohort, name) do
               nil  -> %Cohort{name: name, status: status} # Cohort not found, we build one
               cohort -> cohort          # Cohort exists, let's update it
             end
             |> Cohort.changeset(changes)
             |> Repo.insert_or_update

    case result do
      {:ok, model}        -> # Inserted or updated with success
      {:error, changeset} -> # Something went wrong
    end
  end

  def refresh_student(student) do
  end

end
# import IEx; IEx.pry
