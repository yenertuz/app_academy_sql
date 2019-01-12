def reload1
	reload!
	load "./movie_buff/01_queries.rb"
	load "./movie_buff/02_queries.rb"
	load "./movie_buff/03_queries.rb"
end

def rspec(number)
	system "clear"
	n_s = number.to_s
	command = "rspec spec/0"
	command << n_s
	command << "_queries_spec.rb"
	system command
end

class Actor < ApplicationRecord
  has_many :castings,
    class_name: :Casting,
    foreign_key: :actor_id,
    primary_key: :id

  has_many :movies,
    through: :castings,
    source: :movie

  has_many :directed_movies,
    class_name: :Movie,
    foreign_key: :director_id,
	primary_key: :id
	

end
