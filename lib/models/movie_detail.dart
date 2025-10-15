// Leírás
import 'movie.dart';

class MovieDetail {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final int? voteCount;
  final String? releaseDate;
  final int? runtime;
  final String? tagline;
  final List<Genre>? genres;
  final int? budget;
  final int? revenue;

  MovieDetail({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.voteCount,
    this.releaseDate,
    this.runtime,
    this.tagline,
    this.genres,
    this.budget,
    this.revenue,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      title: json['title'] ?? 'Nincs cím',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'],
      releaseDate: json['release_date'],
      runtime: json['runtime'],
      tagline: json['tagline'],
      genres: json['genres'] != null
          ? (json['genres'] as List).map((g) => Genre.fromJson(g)).toList()
          : null,
      budget: json['budget'],
      revenue: json['revenue'],
    );
  }

  bool get hasPoster => posterPath != null && posterPath!.isNotEmpty;
  bool get hasBackdrop => backdropPath != null && backdropPath!.isNotEmpty;
  bool get hasRating => voteAverage != null && voteAverage! > 0;
  bool get hasOverview => overview != null && overview!.isNotEmpty;
  bool get hasTagline => tagline != null && tagline!.isNotEmpty;
  bool get hasRuntime => runtime != null && runtime! > 0;
  bool get hasGenres => genres != null && genres!.isNotEmpty;
  bool get hasReleaseDate => releaseDate != null && releaseDate!.isNotEmpty;
}
