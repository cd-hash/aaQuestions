require "sqlite3"
require "singleton"

class QuestionsDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super("questions.db")
    self.type_translations = true
    self.results_as_hash = true
  end
end
