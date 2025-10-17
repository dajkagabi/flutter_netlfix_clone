import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie_detail.dart';
import '../services/tmdb_service.dart';
import '../providers/favorites_provider.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<MovieDetail?> _movieDetailFuture;
  final TMDbService _tmdbService = TMDbService();

  @override
  void initState() {
    super.initState();
    _loadMovieData();
  }

  void _loadMovieData() {
    setState(() {
      _movieDetailFuture = _tmdbService.getMovieDetails(widget.movieId);
    });
  }

  //  Film létrehozása a részletekből
  Movie _createMovieFromDetail(MovieDetail detail) {
    return Movie(
      id: detail.id,
      title: detail.title,
      overview: detail.overview ?? '',
      posterPath: detail.posterPath,
      backdropPath: detail.backdropPath,
      voteAverage: detail.voteAverage ?? 0.0,
      releaseDate: detail.releaseDate ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<MovieDetail?>(
        //Betötlés állapotok, hibák kezelése
        future: _movieDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasError || snapshot.data == null) {
            return _buildErrorState();
          }

          final film = snapshot.data!;
          final movie = _createMovieFromDetail(film);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      film.hasBackdrop
                          ? Image.network(
                              TMDbService.getImageUrl(film.backdropPath),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[900],
                              child: const Center(
                                child: Icon(
                                  Icons.movie_creation_outlined,
                                  color: Colors.white54,
                                  size: 80,
                                ),
                              ),
                            ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: [
                              Colors.black.withOpacity(0.9),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  // Kedvenc gomb a Provider-rel
                  Consumer<FavoritesProvider>(
                    builder: (context, favoritesProvider, child) {
                      final isFavorite = favoritesProvider.isFavorite(movie);
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(movie);

                          // Visszajelzés a felhasználónak
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? 'Eltávolítva a kedvencekből'
                                    : 'Hozzáadva a kedvencekhez',
                              ),
                              backgroundColor: isFavorite
                                  ? Colors.grey
                                  : Colors.red,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        film.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (film.hasRating)
                            _buildInfoChip(
                              '⭐ ${film.voteAverage!.toStringAsFixed(1)}',
                            ),
                          if (film.hasReleaseDate)
                            _buildInfoChip(film.releaseDate!.substring(0, 4)),
                          if (film.hasRuntime)
                            _buildInfoChip('${film.runtime!} perc'),
                          if (!film.hasRating &&
                              !film.hasReleaseDate &&
                              !film.hasRuntime)
                            _buildInfoChip('Információ nem elérhető'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (film.hasGenres) ...[
                        Wrap(
                          spacing: 8,
                          children: film.genres!
                              .map(
                                (genre) => Chip(
                                  label: Text(
                                    genre.name,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (film.hasTagline) ...[
                        Text(
                          '"${film.tagline!}"',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (film.hasOverview) ...[
                        const Text(
                          'Történet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          film.overview!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'Történet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ehhez a filmhez még nem készült leírás.',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.red),
          SizedBox(height: 16),
          Text('Film betöltése...', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Hiba a film betöltésében',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Nem sikerült betölteni a film adatait. Kérjük, próbáld újra később.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadMovieData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Újrapróbálás'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String szoveg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        szoveg,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
