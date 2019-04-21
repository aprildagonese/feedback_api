# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_21_174831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id"
    t.integer "value"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "group_members", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_members_on_group_id"
    t.index ["user_id"], name: "index_group_members_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "survey_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_groups_on_survey_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "answer_id"
    t.integer "response_user_id"
    t.integer "target_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_responses_on_answer_id"
    t.index ["response_user_id", "target_user_id"], name: "index_responses_on_response_user_id_and_target_user_id", unique: true
    t.index ["target_user_id", "response_user_id"], name: "index_responses_on_target_user_id_and_response_user_id", unique: true
  end

  create_table "survey_questions", force: :cascade do |t|
    t.bigint "survey_id"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_survey_questions_on_question_id"
    t.index ["survey_id"], name: "index_survey_questions_on_survey_id"
  end

  create_table "surveys", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "group_members", "groups"
  add_foreign_key "group_members", "users"
  add_foreign_key "groups", "surveys"
  add_foreign_key "responses", "answers"
  add_foreign_key "survey_questions", "questions"
  add_foreign_key "survey_questions", "surveys"
end
