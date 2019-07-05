defmodule FeedbackApi.UserTest do
   use FeedbackApi.DataCase

   alias FeedbackApi.User

   describe "Active Instructors" do
      setup do
         instructor_1 = %User{name: "Mike Dao", api_key: "redlobster", role: :Instructor} |> Repo.insert!()
         instructor_2 = %User{name: "Josh Mejia", api_key: "getofftheshed", role: :Instructor} |> Repo.insert!()
         inactive_instructor = %User{name: "Hashtag Steve", api_key: "inactive", status: :Inactive, role: :Instructor} |> Repo.insert!()
         {:ok, users: [instructor_1, instructor_2, inactive_instructor]}
      end

      test "Returns a list of all active instructors excluding the current instructor account", %{users: [mike, josh, _inactive]} do
         result = User.active_instructors(mike)
         
         assert length(result) == 1
         [user] = result
         assert user.id == josh.id
         assert user.name == josh.name
         assert user.status == :Active
      end
   end
end