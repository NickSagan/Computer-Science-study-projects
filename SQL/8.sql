SELECT people.name
FROM movies, people, stars
WHERE movies.id = stars.movie_id
AND stars.person_id = people.id
AND movies.title LIKE "Toy Story";