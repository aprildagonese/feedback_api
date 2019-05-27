defmodule FeedbackApiWeb.Surveys.StudentAverageView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.SurveyView
  alias FeedbackApiWeb.Surveys.StudentAverageView

  def render("show.json", %{average: average}) do
    render_one(average, StudentAverageView, "student_average.json")
  end

  def render("student_average.json", %{student_average: student_average}) do
    %{
      survey: render_one(student_average.survey, SurveyView, "survey.json"),
      averages:
        Enum.map(student_average.average, fn student ->
          %{
            user_id: student.user_id,
            question_id: student.question_id,
            fullName: student.user_name,
            average_rating: student.average_rating
          }
        end)
    }
  end
end
