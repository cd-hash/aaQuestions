# frozen_string_literal: true

require_relative '../db_conn'
require_relative './user'
require_relative './question'

# ORM class for QuestionFollows table
class QuestionFollows
  attr_reader :user_id, :question_id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM question_follows')
    data.map { |datum| QuestionFollows.new(datum) }
  end

  def self.find_by_id(question_follows_id)
    data = QuestionsDBConnection.instance.get_first_row(<<-SQL, question_follows_id: question_follows_id)
      SELECT *
      FROM question_follows
      WHERE question_follows.id=:question_follows_id
    SQL
    QuestionFollows.new(data)
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id: question_id)
      SELECT users.*
      FROM question_follows qf
      LEFT JOIN users ON qf.user_id=users.id
      WHERE qf.question_id=:question_id
    SQL
    data.map { |datum| User.new(datum) }
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id: user_id)
      SELECT questions.*
      FROM question_follows qf
      LEFT JOIN questions ON qf.question_id=questions.id
      WHERE qf.user_id=:user_id
    SQL
    data.map { |datum| Question.new(datum) }
  end

  def self.most_followed_questions(limit_n)
    data = QuestionsDBConnection.instance.execute(<<-SQL, limit_n: limit_n)
      SELECT questions.id question_id
      , COUNT(questions.id) follower_count
      , questions.*
      FROM question_follows qf
      LEFT JOIN questions ON qf.question_id=questions.id
      GROUP BY question_id
      ORDER BY follower_count DESC
      LIMIT :limit_n
    SQL
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
