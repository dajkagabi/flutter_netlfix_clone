//Leírás

class MovieDetail {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final double? voteAverage;
  final int? voteCount;
  final String? releaseDate;
  final int? runtime;
  final List<Genre>? genres;
  final String? tagline;

  MovieDetail({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.voteAverage,
    this.voteCount,
    this.releaseDate,
    this.runtime,
    this.genres,
    this.tagline,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? 'Cím nem elérhető',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: (json['overview'] as String?)?.isNotEmpty == true
          ? json['overview'] as String?
          : 'Ehhez a filmhez még nem készült leírás.',
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      releaseDate: json['release_date'] as String?,
      runtime: json['runtime'] as int?,
      tagline: (json['tagline'] as String?)?.isNotEmpty == true
          ? json['tagline'] as String?
          : null,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((genre) => Genre.fromJson(genre))
          .toList(),
    );
  }

  bool get hasOverview =>
      overview != null &&
      overview!.isNotEmpty &&
      overview != 'Ehhez a filmhez még nem készült leírás.';
  bool get hasPoster => posterPath != null && posterPath!.isNotEmpty;
  bool get hasBackdrop => backdropPath != null && backdropPath!.isNotEmpty;
  bool get hasGenres => genres != null && genres!.isNotEmpty;
  bool get hasTagline => tagline != null && tagline!.isNotEmpty;
  bool get hasRating => voteAverage != null && voteAverage! > 0;
  bool get hasRuntime => runtime != null && runtime! > 0;
  bool get hasReleaseDate => releaseDate != null && releaseDate!.isNotEmpty;
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'] as int, name: json['name'] as String);
  }
}
