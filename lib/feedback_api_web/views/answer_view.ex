defmodule FeedbackApiWeb.AnswerView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.AnswerView

  def render("index.json", %{answers: answers}) do
    render_many(answers, AnswerView, "answer.json")
  end

  def render("show.json", %{answer: answer}) do
    render_one(answer, AnswerView, "answer.json")
  end

  def render("answer.json", %{answer: answer}) do
    %{description: answer.description, pointValue: answer.value}
  end
end
