class Survey < ApplicationRecord
  has_many :groups
  has_many :survey_questions

  enum status: %i[saved sent]

  def self.generate(params)
    survey = self.new(name: params[:survey_name])
    if survey.save
      survey.create_groups(params[:groups])
      survey.create_questions(params[:questions])
    end
  end

  def create_groups(groups)
    groups.each do |group_data|
      group = Group.create!(name: group_data["name"], survey: self)
      group_data[:members].each do |member_id|
        user = User.find(member_id)
        GroupMember.create!(group: group, user: user)
      end
    end
  end

  def create_questions(questions)
    questions.each do |question_data|
      question = Question.create!(text: question_data["text"])
      survey_question = SurveyQuestion.create(survey: self, question: question)
      question_data[:answers].each do |value, description|
        Answer.create!(value: value, description: description, question: question)
      end
    end
  end

end
