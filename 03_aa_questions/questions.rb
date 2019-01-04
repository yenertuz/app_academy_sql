require 'sqlite3'
require 'singleton'

# .headers on
# .mode column

class PlayDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

# users
# questions
# question_follows
# replies
# question_likes

class User
	attr_accessor :id, :fname, :lname

	def initialize(options)
		@id = options["id"]
		@fname = options["fname"]
		@lname = options["lname"]
	end

	def self.find_by_id(id)
		data = PlayDBConnection.instance.execute(<<-SQL, id)
		SELECT * FROM users WHERE id = ? ;
		SQL
		return nil if data.length == 0
		User.new(data[0])
	end

end

class Question
	attr_accessor :id, :title, :body, :user_id

	def initialize(options)
		@id = options["id"]
		@title = options["title"]
		@body = options["body"]
		@user_id = options["user_id"]
	end

	def self.find_by_id(id)
		data = PlayDBConnection.instance.execute(<<-SQL, id)
		SELECT * FROM questions WHERE id = ? ;
		SQL
		return nil if data.length == 0
		Question.new(data[0])
	end

end

class QuestionFollow
	attr_accessor :id, :user_id, :question_id

	def initialize(options)
		@id = options["id"]
		@user_id = options["user_id"]
		@question_id = options["question_id"]
	end

	def self.find_by_id(id)
		data = PlayDBConnection.instance.execute(<<-SQL, id)
		SELECT * FROM question_follows WHERE id = ? ;
		SQL
		return nil if data.length == 0
		QuestionFollow.new(data[0])
	end

end

class Reply
	attr_accessor :id, :user_id, :reply_id, :question_id, :body

	def initialize(options)
		@id = options["id"]
		@user_id = options["user_id"]
		@reply_id = options["reply_id"]
		@question_id = options["question_id"]
		@body = options["body"]
	end

	def self.find_by_id(id)
		data = PlayDBConnection.instance.execute(<<-SQL, id)
		SELECT * FROM replies WHERE id = ? ;
		SQL
		return nil if data.length == 0
		Reply.new(data[0])
	end

end

class QuestionLike
	attr_accessor :id, :question_id, :user_id

	def initialize(options)
		@id = options["id"]
		@question_id = options["question_id"]
		@user_id = options["user_id"]
	end

	def self.find_by_id(id)
		data = PlayDBConnection.instance.execute(<<-SQL, id)
		SELECT * FROM question_likes WHERE id = ? ;
		SQL
		return nil if data.length == 0
		QuestionLike.new(data[0])
	end

end