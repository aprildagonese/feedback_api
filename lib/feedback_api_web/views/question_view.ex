defmodule FeedbackApiWeb.QuestionView do
  use FeedbackApiWeb, :view
  alias FeedbackApiWeb.{QuestionView, AnswerView}

  def render("index.json", %{questions: questions}) do
    render_many(questions, QuestionView, "question.json")
  end

  def render("show.json", %{question: question}) do
    render_one(question, QuestionView, "question.json")
  end

  def render("question.json", %{question: question}) do
    %{text: question.text, answers: render_many(question.answers, AnswerView, "answer.json")}
  end
end
