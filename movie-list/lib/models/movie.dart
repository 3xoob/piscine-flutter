class Movie {
  final String genre;
  final String imdbRating;
  final String title;
  final String poster;

  final String year;
  final String director;
  final String actors;
  final String runtime;
  final String plot;

  Movie(
    this.genre,
    this.imdbRating,
    this.title,
    this.poster,
    this.year,
    this.director,
    this.actors,
    this.runtime,
    this.plot,
  );

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      (json['genre'] ?? json['Genre'] ?? '') as String,
      (json['imdbRating'] ?? json['imdb_rating'] ?? '') as String,
      (json['title'] ?? json['Title'] ?? '') as String,
      (json['poster'] ?? json['Poster'] ?? '') as String,
      (json['year'] ?? json['Year'] ?? '') as String,
      (json['director'] ?? json['Director'] ?? '') as String,
      (json['actors'] ?? json['Actors'] ?? '') as String,
      (json['runtime'] ?? json['Runtime'] ?? '') as String,
      (json['plot'] ?? json['Plot'] ?? '') as String,
    );
  }

  double get ratingAsDouble {
    return double.tryParse(imdbRating) ?? 0.0;
  }
}

