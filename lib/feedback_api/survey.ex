defmodule FeedbackApi.Survey do
  use Ecto.Schema
  import Ecto.{Enum, Query, Changeset}
  alias FeedbackApi.{Survey, Question, User, Repo, Group}

  defenum(StatusEnum, Active: 0, Closed: 1, Disabled: 3)

  schema "surveys" do
    field :name, :string
    field :status, StatusEnum, default: :Active
    field :exp_date, :naive_datetime
    belongs_to :user, User
    has_many :groups, Group
    has_many :questions, Question

    timestamps()
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [:name, :status, :exp_date, :user_id])
    |> validate_required([:name, :status, :user_id])
  end

  def for_user(user) do
    Repo.all(
      from survey in Survey,
        left_join: groups in assoc(survey, :groups),
        left_join: users in assoc(groups, :users),
        left_join: cohort in assoc(users, :cohort),
        left_join: questions in assoc(survey, :questions),
        left_join: answers in assoc(questions, :answers),
        where: survey.user_id == ^user.id,
        order_by: [asc: survey.status, desc: survey.inserted_at, desc: answers.value],
        preload: [
          groups: {groups, users: {users, cohort: cohort}},
          questions: {questions, answers: answers}
        ]
    )
  end

  def for_participant(user) do
    Repo.all(
      from survey in Survey,
        join: groups in assoc(survey, :groups),
        join: users in assoc(groups, :users),
        join: members in assoc(groups, :users),
        join: cohort in assoc(users, :cohort),
        join: questions in assoc(survey, :questions),
        join: answers in assoc(questions, :answers),
        where: users.id == ^user.id,
        where: members.id != ^user.id,
        order_by: [asc: members.id, desc: answers.value, desc: survey.status, asc: survey.id],
        preload: [
          groups: {groups, users: {members, cohort: cohort}},
          questions: {questions, answers: answers}
        ]
    )
  end

  def one(id) do
    Repo.one(
      from survey in Survey,
        left_join: groups in assoc(survey, :groups),
        left_join: users in assoc(groups, :users),
        left_join: cohort in assoc(users, :cohort),
        left_join: questions in assoc(survey, :questions),
        left_join: answers in assoc(questions, :answers),
        where: survey.id == ^id,
        order_by: [asc: users.id, desc: survey.inserted_at, desc: answers.value],
        preload: [
          groups: {groups, users: {users, cohort: cohort}},
          questions: {questions, answers: answers}
        ]
    )
  end

  def pending_for_user(user) do
    # Would like to do in one query using having, just trying to make sure it works for now
    Repo.all(
      from survey in Survey,
        join: groups in assoc(survey, :groups),
        join: members in assoc(groups, :users),
        left_join: cohort in assoc(members, :cohort),
        join: questions in assoc(survey, :questions),
        join: answers in assoc(questions, :answers),
        where: members.id != ^user.id,
        where: survey.status == 0,
        where: groups.id in ^Enum.map(user.groups, fn x -> x.id end),
        where:
          survey.id not in ^Repo.all(
            from s in Survey,
              join: q in assoc(s, :questions),
              join: r in assoc(q, :responses),
              where: r.reviewer_id == ^user.id,
              select: s.id
          ),
        order_by: [asc: members.id, desc: answers.value, asc: survey.id],
        preload: [
          groups: {groups, users: {members, cohort: cohort}},
          questions: {questions, answers: answers}
        ]
    )
  end

  def closed_for_user(user) do
    Repo.all(
      from survey in Survey,
        join: groups in assoc(survey, :groups),
        join: users in assoc(groups, :users),
        join: cohorts in assoc(users, :cohort),
        join: questions in assoc(survey, :questions),
        join: answers in assoc(questions, :answers),
        where: survey.status == 1,
        where: users.id != ^user.id,
        where: groups.id in ^Enum.map(user.groups, fn group -> group.id end),
        order_by: [desc: survey.id],
        preload: [
          groups: {groups, users: {users, cohort: cohorts}},
          questions: {questions, answers: answers}
        ]
    )
  end

  def averages(survey_id) do
    Repo.all(
      from question in Question,
        join: answers in assoc(question, :answers),
        join: responses in assoc(answers, :responses),
        where: question.survey_id == ^survey_id,
        group_by: question.id,
        order_by: [asc: question.id],
        select: %{id: question.id, text: question.text, average: avg(answers.value)}
    )
  end

  def average_for_user(survey_id, user) do
    Repo.all(
      from question in Question,
        left_join: responses in assoc(question, :responses),
        join: recipient in assoc(responses, :recipient),
        join: answers in assoc(responses, :answer),
        where: question.survey_id == ^survey_id,
        where: responses.recipient_id == ^user.id,
        group_by: [question.id, recipient.name, responses.recipient_id],
        select: %{
          question_id: question.id,
          user_name: recipient.name,
          user_id: responses.recipient_id,
          average_rating: avg(answers.value)
        }
    )
  end

  def user_averages(survey_id) do
    Repo.all(
      from question in Question,
        left_join: responses in assoc(question, :responses),
        join: recipient in assoc(responses, :recipient),
        join: answers in assoc(responses, :answer),
        where: question.survey_id == ^survey_id,
        group_by: [question.id, recipient.name, responses.recipient_id],
        order_by: [asc: responses.recipient_id, asc: question.id],
        select: %{
          question_id: question.id,
          user_name: recipient.name,
          user_id: responses.recipient_id,
          average_rating: avg(answers.value)
        }
    )
  end

  def expire_old_surveys do
    from(survey in Survey,
      where: survey.status == 0,
      where: survey.exp_date < ^NaiveDateTime.utc_now(),
      update: [set: [status: 1, updated_at: ^NaiveDateTime.utc_now()]]
    )
    |> Repo.update_all([])
  end
end
