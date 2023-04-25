# frozen_string_literal: true

require_relative '../db_conn'

# ORM class for Question Like table
class QuestionLikes
  attr_reader :user_id, :question_id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM question_likes')
    data.map { |datum| QuestionLikes.new(datum) }
  end

  def self.find_by_id(question_likes_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_likes_id: question_likes_id)
      SELECT *
      FROM question_likes
      WHERE question_likes.id=:question_likes_id
    SQL
    QuestionLikes.new(data[0])
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
