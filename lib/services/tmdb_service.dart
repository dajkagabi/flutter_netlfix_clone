import 'dart:convert';
import 'package:flutter_netlfix_clone/models/movie_detail.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TMDbService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'bbc3e7667feec0318a7b4ab40b629cdc';
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String _language = 'hu-HU';

  final http.Client _client;

  TMDbService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Movie>> getNowPlayingMovies() async {
    try {
      final response = await _client.get(
        Uri.parse(
          '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=$_language',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        final List<Movie> movies = [];
        for (final movieJson in results) {
          try {
            final movie = Movie.fromJson(movieJson);
            if (movie.id > 0) {
              movies.add(movie);
            }
          } catch (e) {
            print('Hiba a film feldolgozásában: $e');
          }
        }
        return movies;
      } else {
        print('API Hiba ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Hálózati hiba: $e');
      return [];
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await _client.get(
        Uri.parse(
          '$_baseUrl/movie/popular?api_key=$_apiKey&language=$_language',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        final List<Movie> movies = [];
        for (final movieJson in results) {
          try {
            final movie = Movie.fromJson(movieJson);
            if (movie.id > 0) {
              movies.add(movie);
            }
          } catch (e) {
            print('Hiba a film feldolgozásában: $e');
          }
        }
        return movies;
      } else {
        print('API Hiba ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Hálózati hiba: $e');
      return [];
    }
  }

  Future<MovieDetail?> getMovieDetails(int movieId) async {
    try {
      final response = await _client.get(
        Uri.parse(
          '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=$_language',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return MovieDetail.fromJson(data);
      } else {
        print('API Hiba ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Hálózati hiba: $e');
      return null;
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    try {
      final response = await _client.get(
        Uri.parse(
          '$_baseUrl/movie/top_rated?api_key=$_apiKey&language=$_language',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        final List<Movie> movies = [];
        for (final movieJson in results) {
          try {
            final movie = Movie.fromJson(movieJson);
            if (movie.id > 0) {
              movies.add(movie);
            }
          } catch (e) {
            print('Hiba a film feldolgozásában: $e');
          }
        }
        return movies;
      } else {
        print('API Hiba ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Hálózati hiba: $e');
      return [];
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    try {
      final response = await _client.get(
        Uri.parse(
          '$_baseUrl/movie/upcoming?api_key=$_apiKey&language=$_language',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        final List<Movie> movies = [];
        for (final movieJson in results) {
          try {
            final movie = Movie.fromJson(movieJson);
            if (movie.id > 0) {
              movies.add(movie);
            }
          } catch (e) {
            print('Hiba a film feldolgozásában: $e');
          }
        }
        return movies;
      } else {
        print('API Hiba ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Hálózati hiba: $e');
      return [];
    }
  }

  Future<List<Movie>> getTrendingMovies() async {
    try {
      final response = await _client.get(
        Uri.parse(
          '$_baseUrl/trending/movie/week?api_key=$_apiKey&language=$_language',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        final List<Movie> movies = [];
        for (final movieJson in results) {
          try {
            final movie = Movie.fromJson(movieJson);
            if (movie.id > 0) {
              movies.add(movie);
            }
          } catch (e) {
            print('Hiba a film feldolgozásában: $e');
          }
        }
        return movies;
      } else {
        print('API Hiba ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Hálózati hiba: $e');
      return [];
    }
  }

  static String getImageUrl(String? path) {
    return path != null ? '$_imageBaseUrl$path' : '';
  }
}
