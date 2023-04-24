require_relative '../db_conn'

class Question
  attr_reader :title, :body, :author_id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM questions')
    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id: question_id)
      SELECT *
      FROM questions
      WHERE questions.id=:question_id
    SQL
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
end
