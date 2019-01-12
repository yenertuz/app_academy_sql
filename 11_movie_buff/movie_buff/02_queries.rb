def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between
  # 3 and 5 (inclusive).
  # Show the id, title, year, and score.
Movie.where("yr between 1980 and 1989 and score between 3 and 5").select(:id, :title, :score, :yr)
end

def bad_years
  # List the years in which a movie with a rating above 8 was not released.
  objects = Movie.find_by_sql(<<-SQL)
  SELECT DISTINCT yr FROM movies
  WHERE yr NOT IN 
  (SELECT yr FROM movies
	WHERE score >= 8)
  SQL
  objects.pluck(:yr)
end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.
  Actor.joins(:movies).where(movies: {title: title}).order("castings.ord asc").select("actors.id, actors.name")
end

def vanity_projects
  # List the title of all movies in which the director also appeared
  # as the starring actor.
  # Show the movie id and title and director's name.

  # Note: Directors appear in the 'actors' table.
  Movie.find_by_sql(<<-SQL)
  SELECT movies.id, movies.title, actors.name FROM movies
  JOIN actors ON actors.id=movies.director_id
  WHERE movies.director_id =
  (SELECT actor_id FROM castings WHERE castings.movie_id=movies.id
	AND ord=1)
	SQL
end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name and number of supporting roles.
  Casting.find_by_sql(<<-SQL)
  SELECT castings.actor_id as id, actors.name, count(castings.actor_id) as roles
  FROM castings
  JOIN actors ON actors.id=castings.actor_id
  WHERE castings.ord != 1
  GROUP BY castings.actor_id, actors.name
  ORDER BY count(castings.actor_id) DESC
  LIMIT 2
  SQL
end
