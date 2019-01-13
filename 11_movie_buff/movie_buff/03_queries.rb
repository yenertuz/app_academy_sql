def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
Movie
.joins(:actors)
.where(actors: {name: those_actors})
.select("movies.title, movies.id")
.group(:id)
.having("COUNT(actors.id) >= ?", those_actors.length)
end

def golden_age
  # Find the decade with the highest average movie score.
  Movie
  .select("AVG(score), (yr / 10) * 10 AS decade")
  .group("decade")
  .order("AVG(score) DESC")
  .first
  .decade

end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery
Actor
.joins(:castings)
.distinct
.where.not(name: name)
.where("
	castings.movie_id IN
	(SELECT movies.id FROM movies
	JOIN castings ON castings.movie_id = movies.id
	JOIN actors ON actors.id = castings.actor_id
	WHERE actors.name = ?)", name)
.pluck(:name)

	end



def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie
  Actor.where("actors.id NOT IN (SELECT distinct castings.actor_id FROM castings)").count(:id)
end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"

  # LOWER

  whazzername.downcase!
  like_string = whazzername.chars.join("%")
  like_string = "%" + like_string + "%"

  Movie.joins(:actors)
  .where("LOWER(actors.name) LIKE ?", like_string)
  .distinct

end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.
  Actor.select("id, name, 
		(COALESCE(
		(SELECT movies.yr FROM movies
		JOIN castings ON movies.id=castings.movie_id
		WHERE castings.actor_id = actors.id
		ORDER BY movies.yr DESC LIMIT 1)
		, 0) 
		-
		COALESCE(
			(SELECT movies.yr FROM movies
			JOIN castings ON movies.id=castings.movie_id
			WHERE castings.actor_id = actors.id
			ORDER BY movies.yr ASC LIMIT 1)
			, 0)) AS career
		").order("career DESC").limit(3)

end
