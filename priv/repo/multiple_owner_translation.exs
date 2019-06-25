alias FeedbackApi.{Repo, Survey, User}
import Ecto.Query

Repo.all(from survey in Survey,
   left_join: owners in assoc(survey, :owners),
   where: is_nil(owners.id),
   preload: [:user, :owners])
   |> Enum.each(fn survey -> Ecto.Changeset.change(survey) 
      |> Ecto.Changeset.put_assoc(:owners, [survey.user]) 
      |> Repo.update!() 
      end)