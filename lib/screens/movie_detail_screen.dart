import 'package:flutter/material.dart';
import '../models/movie_detail.dart';
import '../services/tmdb_service.dart';

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
    _movieDetailFuture = _tmdbService.getMovieDetails(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<MovieDetail?>(
        future: _movieDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Film betöltése...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
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
                    onPressed: () {
                      setState(() {
                        _movieDetailFuture = _tmdbService.getMovieDetails(
                          widget.movieId,
                        );
                      });
                    },
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

          final film = snapshot.data!;
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
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Kedvencek funkció hamarosan...'),
                          backgroundColor: Colors.red,
                        ),
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
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Trailer lejátszása hamarosan...'),
              backgroundColor: Colors.red,
            ),
          );
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Lejátszás'),
        backgroundColor: Colors.red,
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
