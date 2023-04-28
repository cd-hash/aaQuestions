# frozen_string_literal: true

require_relative '../db_conn'
require_relative './question'
require_relative './replies'
require_relative './question_follows'
require_relative './question_likes'

# ORM class for Users table
class User
  attr_reader :first_name, :last_name

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM users')
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_id(user_id)
    data = QuestionsDBConnection.instance.get_first_row(<<-SQL, user_id: user_id)
      SELECT *
      FROM users
      WHERE users.id=:user_id
    SQL
    User.new(data)
  end

  def self.find_by_name(first_name, last_name)
    data = QuestionsDBConnection.instance.get_first_row(<<-SQL, fname: first_name, lname: last_name)
      SELECT *
      FROM users
      WHERE users.fname=:fname
      AND users.lname=:lname
    SQL
    User.new(data)
  end

  def initialize(options)
    @id = options['id']
    @first_name = options['fname']
    @last_name = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Replies.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLikes.liked_questions_for_user_id(@id)
  end

  def average_karma
    QuestionsDatabase.get_first_value(<<-SQL, author_id: @id)
      SELECT
        AVG(likes) AS avg_karma
      FROM (
        SELECT
          COUNT(question_likes.user_id) AS likes
        FROM
          questions
        LEFT OUTER JOIN
          question_likes ON questions.id = question_likes.question_id
        WHERE
          questions.author_id = :author_id
        GROUP BY
          questions.id
      )
    SQL
  end

  def save
    if @id
      update
    else
      insert
    end
  end

  def insert
    QuestionsDBConnection.instance.execute(<<-SQL, fname: @first_name, lname: @last_name)
      INSERT INTO
        users (fname, lname)
      VALUES
        (:fname, :lname)
    SQL
    @id = QuestionsDBConnection.instance.last_insert_row_id
  end

  def update
    QuestionsDBConnection.instance.execute(<<-SQL, id: @id, fname: @first_name, lname: @last_name)
      UPDATE
        users
      SET
        fname = :fname, lname = :lname
      WHERE
        users.id = :id
    SQL
    @id = QuestionsDBConnection.instance.last_insert_row_id
  end
end
