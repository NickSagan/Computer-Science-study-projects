SELECT name FROM people
WHERE people.id IN (
SELECT DISTINCT person_id
FROM directors JOIN ratings ON ratings.movie_id = directors.movie_id
WHERE ratings.rating >= 9.0);