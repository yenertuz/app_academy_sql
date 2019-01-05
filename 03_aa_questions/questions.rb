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
	
	def self.find_by_name(fname, lname)
		data = PlayDBConnection.instance.execute(<<-SQL, fname, lname)
		SELECT * FROM users WHERE fname = ? AND lname = ?;
		SQL
		data.map { |datum|  User.new(datum)       }
	end

	def authored_questions
		raise "#{self} not in database" if @id == nil
		data = PlayDBConnection.instance.execute(<<-SQL, @id)
		SELECT * FROM questions WHERE user_id = ? ;
		SQL
		data.map { |datum| Question.new(datum)  }
	end

	def authored_replies
		raise "#{self} not in database" if @id == nil
		data = PlayDBConnection.instance.execute(<<-SQL, @id)
		SELECT * FROM replies WHERE user_id = ? ;
		SQL
		data.map {  |datum| Reply.new(datum)       }
	end

	def followed_questions
		raise "#{self} not in database" if @id == nil
		data = PlayDBConnection.instance.execute(<<-SQL, @id)
		SELECT questions.* FROM question_follows
		JOIN questions ON questions.id=question_follows.question_id
		WHERE question_follows.user_id = ? ;
		SQL
		data.map { |x| Question.new(x) }
	end

	def liked_questions
		raise "#{self} not in database" if @id == nil
		QuestionLike.liked_questions_for_user_id(@id)
	end

	def average_karma
		raise "#{self} not in database" if @id == nil
		data = PlayDBConnection.instance.execute(<<-SQL, @id)
		select count(question_likes.id), count(distinct questions.id), questions.user_id
		from questions
		left join question_likes on question_likes.question_id=questions.id
		where question_likes.id is not null
		and questions.user_id = ?
		group by questions.user_id;
		SQL
		data = data[0]
		count_questions = data["count(distinct questions.id)"]
		count_likes = data["count(question_likes.id)"]
		count_questions.to_f / count_likes
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

	def self.find_by_author_id(id)
		data = PlayDBConnection.instance.execute(<<-SQL, id)
		SELECT * FROM questions WHERE user_id = ? ;
		SQL
		data.map { |datum| Question.new(datum)   }
	end

	def author
		raise "#{self} not in database" if @id == nil
		data = PlayDBConnection.instance.execute(<<-SQL, @user_id)
		SELECT * FROM users WHERE id = ? ;
		SQL
		return nil if data.length == 0
		User.new(data[0])
	end

	def replies
		raise "#{self} not in database" if @id == nil
		data = PlayDBConnection.instance.execute(<<-SQL, @id)
		SELECT * FROM replies WHERE question_id = ? ;
		SQL
		data.map { |datum| Reply.new(datum)   }
	end

	def followers
		raise "#{self} not in database" if @id == nil
		data = PlayDBConnection.instance.execute(<<-SQL, @id)
		SELECT users.* FROM question_follows
		JOIN users ON question_follows.user_id = users.id
		WHERE question_follows.question_id = ?
		SQL
		data.map { |x| User.new(x) }
	end

	def self.most_followed(n)
		QuestionFollow.most_followed_questions(n)
	end

	def likers
		raise "#{self} not in database" if @id == nil
		QuestionLike.likers_for_question_id(@id)
	end
	
	def num_likes
		raise "#{self} not in database" if @id == nil
		QuestionLike.num_likes_for_question_id(@id)
	end

	def self.most_liked(n)
		QuestionLike.most_liked_questions(n)
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

	def self.followers_for_question_id(question_id)
		data = PlayDBConnection.instance.execute(<<-SQL, question_id)
		SELECT users.* FROM question_follows JOIN users ON users.id=question_follows.user_id
		WHERE question_id = ? ;
		SQL
		data.map { |x| User.new(x) }
	end

	def self.followed_questions_for_user_id(user_id)
		data = PlayDBConnection.instance.execute(<<-SQL, user_id)
		SELECT questions.* FROM question_follows JOIN questions ON questions.id=question_follows.question_id
		WHERE question_follows.user_id = ? ;
		SQL
		data.map { |x| Question.new(x) }
	end

	def self.most_followed_questions(n)
		data = PlayDBConnection.instance.execute(<<-SQL, n)
		SELECT questions.*, count(question_follows.id) from question_follows
		join questions on question_follows.question_id=questions.id
		group by question_follows.question_id
		order by count(question_follows.id)
		limit ? ;
		SQL
		data.map { |x| Question.new(x) }
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

	def self.find_by_user_id(id)
		data = PlayDBConnection.instance.execute(<<-SQL, id)
		SELECT * FROM replies WHERE user_id = ? ;
		SQL
		data.map { |datum| Reply.new(datum)   }
	end

	def self.find_by_question_id(id)
		data = PlayDBConnection.instance.execute(<<-SQL, id)
		SELECT * FROM replies WHERE question_id = ? ;
		SQL
		data.map { |datum| Reply.new(datum)   }
	end

	def author
		raise "#{self} not in database" if @id == nil
		data = PlayDBConnection.instance.execute(<<-SQL, @user_id)
		SELECT * FROM users WHERE id = ? ;
		SQL
		return nil if data.length == 0
		User.new(data[0])
	end

	def question 
		raise "#{self} not in database" if @id == nil
		data = PlayDBConnection.instance.execute(<<-SQL, @question_id)
		SELECT * FROM questions WHERE id = ? ;
		SQL
		return nil if data.length == 0
		Question.new(data[0])
	end 

	def parent_reply
		raise "#{self} not in database" if @id == nil
		data = PlayDBConnection.instance.execute(<<-SQL, @reply_id)
		SELECT * FROM replies WHERE id = ? ;
		SQL
		return nil if data.length == 0
		Reply.new(data[0])
	end

	def child_replies
		raise "#{self} not in database" if @id == nil
		data = PlayDBConnection.instance.execute(<<-SQL, @id)
		SELECT * FROM replies WHERE reply_id = ? ;
		SQL
		data.map { |datum| Reply.new(datum) }
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

	def self.likers_for_question_id(question_id)
		data = PlayDBConnection.instance.execute(<<-SQL, question_id)
		select users.* from question_likes
		join users on question_likes.user_id=users.id
		where question_likes.question_id = ? ;
		SQL
		data.map { |x| User.new(x) }
	end

	def self.num_likes_for_question_id(question_id)
		data = PlayDBConnection.instance.execute(<<-SQL, question_id)
		select count(user_id) from question_likes
		where question_id = ?
		SQL
		data[0]["count(user_id)"]
	end

	def self.liked_questions_for_user_id(user_id)
		data = PlayDBConnection.instance.execute(<<-SQL, user_id)
		select users.* from question_likes
		join users on users.id=question_likes.user_id
		where question_likes.user_id = ? ;
		SQL
		data.map { |x| User.new(x) }
	end

	def self.most_liked_questions(n)
		data = PlayDBConnection.instance.execute(<<-SQL, n)
		select questions.*, count(question_likes.user_id) as count from questions
		join question_likes on questions.id=question_likes.question_id
		group by questions.id
		order by count
		limit ? ;
		SQL
		data.map { |x| Question.new(x) }
	end

end