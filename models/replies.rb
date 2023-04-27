# frozen_string_literal: true

require_relative '../db_conn'
require_relative './user'
require_relative './question'

# ORM class for Replies table
class Replies
  attr_reader :body, :original_question_id, :parent_reply_id, :author_id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM replies')
    data.map { |datum| Replies.new(datum) }
  end

  def self.find_by_id(reply_id)
    data = QuestionsDBConnection.instance.get_first_row(<<-SQL, reply_id: reply_id)
      SELECT *
      FROM replies
      WHERE replies.id=:reply_id
    SQL
    Replies.new(data)
  end

  def self.find_by_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id: user_id)
      SELECT *
      FROM replies
      WHERE replies.author_id=:user_id
    SQL
    data.map { |datum| Replies.new(datum) }
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id: question_id)
      SELECT *
      FROM replies
      WHERE replies.original_question_id=:question_id
    SQL
    data.map { |datum| Replies.new(datum) }
  end

  def self.find_by_parent_id(parent_reply_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, parent_reply_id: parent_reply_id)
      SELECT *
      FROM replies
      WHERE replies.parent_reply_id=:parent_reply_id
    SQL
    data.map { |datum| Replies.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @original_question_id = options['original_question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def question
    Question.find_by_id(@original_question_id)
  end

  def parent_reply
    Replies.find_by_id(@parent_reply_id)
  end

  def child_replies
    Replies.find_by_parent_id(@parent_reply_id)
  end
end
