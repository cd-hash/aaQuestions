# frozen_string_literal: true

require_relative '../db_conn'

# ORM class for QuestionFollows table
class QuestionFollows
  attr_reader :user_id, :question_id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM question_follows')
    data.map { |datum| QuestionFollows.new(datum) }
  end

  def self.find_by_id(question_follows_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_follows_id: question_follows_id)
      SELECT *
      FROM question_follows
      WHERE question_follows.id=:question_follows_id
    SQL
    QuestionFollows.new(data[0])
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
