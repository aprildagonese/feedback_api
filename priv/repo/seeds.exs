alias FeedbackApi.{Repo, Cohort, User}
import Ecto.Query

c_1811 =
  Repo.insert!(
    %Cohort{
      name: "1811"
    }
    |> Repo.preload([:users])
  )

c_1901 =
  Repo.insert!(
    %Cohort{
      name: "1901"
    }
    |> Repo.preload([:users])
  )

Ecto.build_assoc(c_1811, :users, %{
  name: "Peter Lapicola",
  program: "B"
})
|> Repo.insert!()

Ecto.build_assoc(c_1811, :users, %{
  name: "April Dagonese",
  program: "B"
})
|> Repo.insert!()

Ecto.build_assoc(c_1811, :users, %{
  name: "Scott Thomas",
  program: "B"
})
|> Repo.insert!()

Ecto.build_assoc(c_1811, :users, %{
  name: "Peregrine Reed",
  program: "B"
})
|> Repo.insert!()

Ecto.build_assoc(c_1811, :users, %{
  name: "Zach Nager",
  program: "B"
})
|> Repo.insert!()

Ecto.build_assoc(c_1811, :users, %{
  name: "Taylor Sperry",
  program: "F"
})
|> Repo.insert!()

Ecto.build_assoc(c_1811, :users, %{
  name: "Kim Myers",
  program: "F"
})
|> Repo.insert!()

Ecto.build_assoc(c_1811, :users, %{
  name: "Jessica Hansen",
  program: "F"
})
|> Repo.insert!()

Ecto.build_assoc(c_1811, :users, %{
  name: "Michael Krog",
  program: "F"
})
|> Repo.insert!()

Ecto.build_assoc(c_1811, :users, %{
  name: "Tom Wilhoit",
  program: "F"
})
|> Repo.insert!()

Ecto.build_assoc(c_1901, :users, %{
  name: "Earl Stephens",
  program: "B"
})
|> Repo.insert!()

Ecto.build_assoc(c_1901, :users, %{
  name: "Jon Peterson",
  program: "B"
})
|> Repo.insert!()

Ecto.build_assoc(c_1901, :users, %{
  name: "Noah Flint",
  program: "B"
})
|> Repo.insert!()

Ecto.build_assoc(c_1901, :users, %{
  name: "Jennica Stiehl",
  program: "B"
})
|> Repo.insert!()

Ecto.build_assoc(c_1901, :users, %{
  name: "Erin King",
  program: "B"
})
|> Repo.insert!()

Ecto.build_assoc(c_1901, :users, %{
  name: "Rachel Odom",
  program: "F"
})
|> Repo.insert!()

Ecto.build_assoc(c_1901, :users, %{
  name: "Kelly Zick",
  program: "F"
})
|> Repo.insert!()

Ecto.build_assoc(c_1901, :users, %{
  name: "Justin Pyktel",
  program: "F"
})
|> Repo.insert!()

Ecto.build_assoc(c_1901, :users, %{
  name: "Bridget Coyle",
  program: "F"
})
|> Repo.insert!()

Ecto.build_assoc(c_1901, :users, %{
  name: "Kristen Hallstrom",
  program: "F"
})
|> Repo.insert!()
