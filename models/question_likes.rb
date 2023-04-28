# frozen_string_literal: true

require_relative '../db_conn'
require_relative './user'

# ORM class for Question Like table
class QuestionLikes
  attr_reader :user_id, :question_id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM question_likes')
    data.map { |datum| QuestionLikes.new(datum) }
  end

  def self.find_by_id(question_likes_id)
    data = QuestionsDBConnection.instance.get_first_row(<<-SQL, question_likes_id: question_likes_id)
      SELECT *
      FROM question_likes
      WHERE question_likes.id=:question_likes_id
    SQL
    QuestionLikes.new(data)
  end

  def self.likers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id: question_id)
      SELECT users.*
      FROM question_likes
      LEFT JOIN users
      ON users.id=question_likes.user_id
      WHERE question_likes.question_id=:question_id
    SQL
    data.map { |datum| User.new(datum) }
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDBConnection.instance.get_first_row(<<-SQL, question_id: question_id)
      SELECT COUNT(users.id) num_likers
      FROM question_likes
      LEFT JOIN users
      ON users.id=question_likes.user_id
      WHERE question_likes.question_id=:question_id
    SQL
    data['num_likers']
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
