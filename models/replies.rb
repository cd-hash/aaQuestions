# frozen_string_literal: true

require_relative '../db_conn'

# ORM class for Replies table
class Replies
  attr_reader :body, :original_question_id, :parent_reply_id, :author_id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM replies')
    data.map { |datum| Replies.new(datum) }
  end

  def self.find_by_id(reply_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, reply_id: reply_id)
      SELECT *
      FROM replies
      WHERE replies.id=:reply_id
    SQL
    Replies.new(data[0])
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @original_question_id = options['original_question_id']
    @parent_reply_id = options['parent_reply_id']
    @author_id = options['author_id']
  end
end
