import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/movie_detail.dart';

class TMDbService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'bbc3e7667feec0318a7b4ab40b629cdc';
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  final http.Client client;

  TMDbService({http.Client? client}) : client = client ?? http.Client();

  // Kép URL generálás
  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }
    return '$_imageBaseUrl$path';
  }

  // HTTP kérés helper metódus
  Future<Map<String, dynamic>> _makeRequest(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint?api_key=$_apiKey&language=hu-HU');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  // Popular filmek
  Future<List<Movie>> getPopularMovies() async {
    try {
      final data = await _makeRequest('/movie/popular');
      final results = data['results'] as List;
      return results.map((movieData) => Movie.fromJson(movieData)).toList();
    } catch (e) {
      throw Exception('Failed to load popular movies: $e');
    }
  }

  // Most játszott filmek
  Future<List<Movie>> getNowPlayingMovies() async {
    try {
      final data = await _makeRequest('/movie/now_playing');
      final results = data['results'] as List;
      return results.map((movieData) => Movie.fromJson(movieData)).toList();
    } catch (e) {
      throw Exception('Failed to load now playing movies: $e');
    }
  }

  // Legjobbra értékelt filmek
  Future<List<Movie>> getTopRatedMovies() async {
    try {
      final data = await _makeRequest('/movie/top_rated');
      final results = data['results'] as List;
      return results.map((movieData) => Movie.fromJson(movieData)).toList();
    } catch (e) {
      throw Exception('Failed to load top rated movies: $e');
    }
  }

  // Hamarosan jövő filmek
  Future<List<Movie>> getUpcomingMovies() async {
    try {
      final data = await _makeRequest('/movie/upcoming');
      final results = data['results'] as List;
      return results.map((movieData) => Movie.fromJson(movieData)).toList();
    } catch (e) {
      throw Exception('Failed to load upcoming movies: $e');
    }
  }

  // Trend filmek
  Future<List<Movie>> getTrendingMovies() async {
    try {
      final data = await _makeRequest('/trending/movie/week');
      final results = data['results'] as List;
      return results.map((movieData) => Movie.fromJson(movieData)).toList();
    } catch (e) {
      throw Exception('Failed to load trending movies: $e');
    }
  }

  // Film részletek
  Future<MovieDetail?> getMovieDetails(int movieId) async {
    try {
      final data = await _makeRequest('/movie/$movieId');
      return MovieDetail.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load movie details: $e');
    }
  }

  // Film keresés
  Future<List<Movie>> searchMovies(String query) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&language=hu-HU&query=$query',
      );
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }

  void dispose() {
    client.close();
  }
}
