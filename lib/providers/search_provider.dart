import 'package:flutter/material.dart';
import '../services/tmdb_service.dart';
import '../models/movie.dart';

class SearchProvider with ChangeNotifier {
  final TMDbService _tmdbService = TMDbService();

  List<Movie> _searchResults = [];
  bool _isSearching = false;
  String _searchQuery = '';
  String? _searchError;

  List<Movie> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  String? get searchError => _searchError;

  // Keresés végrehajtása
  Future<void> searchMovies(String query) async {
    if (query == _searchQuery && query.isNotEmpty) return;

    _searchQuery = query;
    _isSearching = true;
    _searchError = null;
    notifyListeners();

    try {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = await _tmdbService.searchMovies(query);
      }
    } catch (e) {
      _searchError = 'Hiba a keresés során: $e';
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // Keresés törlése
  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    _searchError = null;
    notifyListeners();
  }
}
