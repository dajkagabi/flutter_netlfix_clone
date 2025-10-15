import 'package:flutter/material.dart';
import '../services/tmdb_service.dart';
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  final TMDbService _tmdbService;

  List<Movie> _popularMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _trendingMovies = [];
  bool _isLoading = false;
  String? _error;

  MovieProvider() : _tmdbService = TMDbService();

  // GETTEREK
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get trendingMovies => _trendingMovies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ÖSSZES FILM EGYSZERRE
  Future<void> loadAllMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([
        loadPopularMovies(),
        loadNowPlayingMovies(),
        loadTopRatedMovies(),
        loadUpcomingMovies(),
        loadTrendingMovies(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Popular filmek betöltése
  Future<void> loadPopularMovies() async {
    _popularMovies = await _tmdbService.getPopularMovies();
    notifyListeners();
  }

  // Now playing filmek betöltése
  Future<void> loadNowPlayingMovies() async {
    _nowPlayingMovies = await _tmdbService.getNowPlayingMovies();
    notifyListeners();
  }

  // Top rated filmek betöltése
  Future<void> loadTopRatedMovies() async {
    _topRatedMovies = await _tmdbService.getTopRatedMovies();
    notifyListeners();
  }

  // Upcoming filmek betöltése
  Future<void> loadUpcomingMovies() async {
    _upcomingMovies = await _tmdbService.getUpcomingMovies();
    notifyListeners();
  }

  // Trending filmek betöltése
  Future<void> loadTrendingMovies() async {
    _trendingMovies = await _tmdbService.getTrendingMovies();
    notifyListeners();
  }
}
