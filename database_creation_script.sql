CREATE DATABASE movies;

CREATE TABLE movies (
	movie_id VARCHAR(11) PRIMARY KEY,
	movie_title VARCHAR(300) NOT NULL,
	release_year SMALLINT CHECK (release_year > 0),
	length_minutes INT CHECK (length_minutes > 0),
	avg_rating DECIMAL(3, 1) CHECK (avg_rating >= 0 AND avg_rating <= 10),
	num_ratings INT CHECK (num_ratings >= 0)
);

CREATE TABLE actors (
	actor_id VARCHAR(11) PRIMARY KEY,
	actor_name VARCHAR(100) NOT NULL,
	birth_year SMALLINT CHECK (birth_year > 0),
	death_year SMALLINT CHECK (death_year > 0)
);

CREATE TABLE movie_cast (
	movie_id VARCHAR(11),
	actor_id VARCHAR(11),
	known_for BOOL NOT NULL DEFAULT FALSE,
	PRIMARY KEY (movie_id, actor_id),
	FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
	FOREIGN KEY (actor_id) REFERENCES actors(actor_id)
);

CREATE TABLE genres (
	genre_id SMALLINT PRIMARY KEY,
	genre_name VARCHAR(25) NOT NULL UNIQUE
);

CREATE TABLE movie_genres (
	movie_id VARCHAR(11),
	genre_id SMALLINT,
	PRIMARY KEY (movie_id, genre_id),
	FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
	FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
)