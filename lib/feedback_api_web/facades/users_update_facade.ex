defmodule FeedbackApiWeb.UsersUpdateFacade do
  alias FeedbackApi.{User, Cohort, Repo}
  alias Services.Rooster
  import Ecto.Query


  def update_data do
    # update_cohorts()
    deactivate_students()
    # update_students()
    {:ok, []}
  end

  def deactivate_students do
    Repo.update_all(User, set: [status: :inactive])
  end

  def update_cohorts do
    cohorts = Rooster.cohorts()
    Enum.map(cohorts, fn cohort ->
      refresh_cohort(cohort)
    end)
  end

  def refresh_cohort(cohort) do
    name = cohort["attributes"]["name"]
    status = cohort["attributes"]["status"]
    result =
      case Repo.get_by(Cohort, %{name: name}) do
        nil -> %Cohort{}
        cohort -> Ecto.Changeset.change(cohort)
      end
      |> Cohort.changeset(%{name: name, status: status})
      |> Repo.insert_or_update()

    case result do
      {:ok, model} -> {:ok, model}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end

  def update_students(students) do
    Enum.map(students, fn student ->
      refresh_student(student)
    end)
  end

  def refresh_student(student) do
    name = student["attributes"]
  end
end
