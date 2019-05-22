defmodule FeedbackApiWeb.UsersUpdateFacade do
  alias FeedbackApi.{User, Cohort, Repo}
  alias Services.Rooster
  import Ecto.Query

  def update_data do
    update_cohorts()
    deactivate_students()
    update_students()
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

  def update_students do
    cohorts = Rooster.students()
    Enum.map(cohorts, fn cohort ->
      get_students(cohort)
    end)
  end

  def get_students(cohort_data) do
    name = cohort_data["attributes"]["name"]
    cohort = Repo.get_by(Cohort, name: name)
    students = cohort_data["attributes"]["students"]
    Enum.map(students, fn student ->
      update_student(student, cohort)
    end)
  end

  def update_student(student, cohort) do
    name = student["name"]
    program = student["program"]
    cohort = Repo.preload(cohort, [:users])
    result =
      case Repo.get_by(User, %{name: name}) do
        nil -> %User{}
        user -> Ecto.Changeset.change(user)
      end
      |> User.changeset(%{name: name, status: :active, program: program, cohort_id: cohort.id})
      |> Repo.insert_or_update()

    case result do
      {:ok, model} -> {:ok, model}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
