import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/movie.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Movie> _favoriteMovies = [];

  List<Movie> get favoriteMovies => List.unmodifiable(_favoriteMovies);
  bool get hasFavorites => _favoriteMovies.isNotEmpty;
  int get favoritesCount => _favoriteMovies.length;

  // Konstruktor - betölti a kedvenceket az app indításakor
  FavoritesProvider() {
    _loadFromLocalStorage();
  }

  // Film hozzáadása a kedvencekhez
  void addToFavorites(Movie movie) {
    if (!_favoriteMovies.any((m) => m.id == movie.id)) {
      _favoriteMovies.add(movie);
      notifyListeners();
      _saveToLocalStorage();
      debugPrint('Film hozzáadva a kedvencekhez: ${movie.title}');
    }
  }

  // Film eltávolítása a kedvencekből
  void removeFromFavorites(Movie movie) {
    _favoriteMovies.removeWhere((m) => m.id == movie.id);
    notifyListeners();
    _saveToLocalStorage();
    debugPrint('Film eltávolítva a kedvencekből: ${movie.title}');
  }

  // Ellenőrzi, hogy egy film kedvenc-e
  bool isFavorite(Movie movie) {
    return _favoriteMovies.any((m) => m.id == movie.id);
  }

  // Kedvenc váltása
  void toggleFavorite(Movie movie) {
    if (isFavorite(movie)) {
      removeFromFavorites(movie);
    } else {
      addToFavorites(movie);
    }
  }

  //  SharedPreferences-be
  Future<void> _saveToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Filmek listáját JSON formátumba konvertáljuk
      final moviesJson = _favoriteMovies
          .map((movie) => movie.toJson())
          .toList();
      final jsonString = json.encode(moviesJson);

      // Mentés SharedPreferences-be
      await prefs.setString('favorite_movies', jsonString);
      debugPrint('Kedvencek mentve: ${_favoriteMovies.length} film');
    } catch (e) {
      debugPrint('Hiba a kedvencek mentésekor: $e');
    }
  }

  // BETÖLTÉS: SharedPreferences-ből
  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('favorite_movies');

      if (jsonString != null && jsonString.isNotEmpty) {
        // JSON visszaalakítása Movie objektumokká
        final List<dynamic> moviesJson = json.decode(jsonString);
        _favoriteMovies.clear();

        for (final movieJson in moviesJson) {
          try {
            final movie = Movie.fromJson(movieJson);
            _favoriteMovies.add(movie);
          } catch (e) {
            debugPrint('Hiba a film betöltésekor: $e');
          }
        }

        notifyListeners();
        debugPrint('Kedvencek betöltve: ${_favoriteMovies.length} film');
      }
    } catch (e) {
      debugPrint('Hiba a kedvencek betöltésekor: $e');
    }
  }

  // Összes kedvenc törlése
  Future<void> clearAllFavorites() async {
    _favoriteMovies.clear();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('favorite_movies');
      debugPrint('Összes kedvenc törölve');
    } catch (e) {
      debugPrint('Hiba a kedvencek törlésekor: $e');
    }
  }
}
