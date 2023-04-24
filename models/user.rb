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
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id: user_id)
      SELECT *
      FROM users
      WHERE users.id=:user_id
    SQL
    User.new(data[0])
  end

  def initialize(options)
    @id = options['id']
    @first_name = options['fname']
    @last_name = options['lname']
  end
end
