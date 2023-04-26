# frozen_string_literal: true

require_relative '../db_conn'

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
end
