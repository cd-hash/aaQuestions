# frozen_string_literal: true

require_relative '../db_conn'
require_relative './user'
require_relative './replies'

# ORM class for Questions table
class Question
  attr_reader :title, :body, :author_id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM questions')
    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_id(question_id)
    data = QuestionsDBConnection.instance.get_first_row(<<-SQL, question_id: question_id)
      SELECT *
      FROM questions
      WHERE questions.id=:question_id
    SQL
    Question.new(data)
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, author_id: author_id)
      SELECT *
      FROM questions
      WHERE questions.author_id=:author_id
    SQL
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Replies.find_by_question_id(@id)
  end
end
