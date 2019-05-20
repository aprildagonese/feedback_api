<<<<<<< HEAD

=======
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FeedbackApi.Repo.insert!(%FeedbackApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias FeedbackApi.{Repo, Cohort, User}
import Ecto.Query

b_1811 = Repo.insert! %Cohort{
  name: "1811",
  program: "B"
} |> Repo.preload([:users])
f_1811 = Repo.insert! %Cohort{
  name: "1811",
  program: "F"
} |> Repo.preload([:users])
b_1901 = Repo.insert! %Cohort{
  name: "1901",
  program: "B"
} |> Repo.preload([:users])
f_1901 = Repo.insert! %Cohort{
  name: "1901",
  program: "F"
} |> Repo.preload([:users])

Ecto.build_assoc(b_1811, :users, %{
  name: "Peter Lapicola"
  })  |> Repo.insert!()
Ecto.build_assoc(b_1811, :users, %{
  name: "April Dagonese"
  }) |> Repo.insert!()
Ecto.build_assoc(b_1811, :users, %{
  name: "Scott Thomas"
  }) |> Repo.insert!()
Ecto.build_assoc(b_1811, :users, %{
  name: "Peregrine Reed"
  }) |> Repo.insert!()
Ecto.build_assoc(b_1811, :users, %{
  name: "Zach Nager"
  }) |> Repo.insert!()
Ecto.build_assoc(f_1811, :users, %{
  name: "Taylor Sperry"
  }) |> Repo.insert!()
Ecto.build_assoc(f_1811, :users, %{
  name: "Kim Myers"
  }) |> Repo.insert!()
Ecto.build_assoc(f_1811, :users, %{
  name: "Jessica Hansen"
  }) |> Repo.insert!()
Ecto.build_assoc(f_1811, :users, %{
  name: "Michael Krog"
  }) |> Repo.insert!()
Ecto.build_assoc(f_1811, :users, %{
  name: "Tom Wilhoit"
  }) |> Repo.insert!()
Ecto.build_assoc(b_1901, :users, %{
  name: "Earl Stephens"
  }) |> Repo.insert!()
Ecto.build_assoc(b_1901, :users, %{
  name: "Jon Peterson"
  }) |> Repo.insert!()
Ecto.build_assoc(b_1901, :users, %{
  name: "Noah Flint"
  }) |> Repo.insert!()
Ecto.build_assoc(b_1901, :users, %{
  name: "Jennica Stiehl"
  }) |> Repo.insert!()
Ecto.build_assoc(b_1901, :users, %{
  name: "Erin King"
  }) |> Repo.insert!()
Ecto.build_assoc(f_1901, :users, %{
  name: "Rachel Odom"
  }) |> Repo.insert!()
Ecto.build_assoc(f_1901, :users, %{
  name: "Kelly Zick"
  }) |> Repo.insert!()
Ecto.build_assoc(f_1901, :users, %{
  name: "Justin Pyktel"
  }) |> Repo.insert!()
Ecto.build_assoc(f_1901, :users, %{
  name: "Bridget Coyle"
  }) |> Repo.insert!()
Ecto.build_assoc(f_1901, :users, %{
  name: "Kristen Hallstrom"
  }) |> Repo.insert!()
>>>>>>> master
