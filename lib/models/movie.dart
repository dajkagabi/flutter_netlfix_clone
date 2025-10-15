//
class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final double? popularity;
  final double? voteAverage;
  final int? voteCount;
  final String? releaseDate;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.popularity,
    this.voteAverage,
    this.voteCount,
    this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      releaseDate: json['release_date'] as String?,
    );
  }
}
