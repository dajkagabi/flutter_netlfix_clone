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
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hiba a film betöltésében',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _movieDetailFuture = _tmdbService.getMovieDetails(
                          widget.movieId,
                        );
                      });
                    },
                    child: const Text('Újrapróbál'),
                  ),
                ],
              ),
            );
          }

          final movie = snapshot.data!;
          return CustomScrollView(
            slivers: [
              // FEJLÉC KÉP
              SliverAppBar(
                expandedHeight: 400,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      movie.backdropPath != null
                          ? Image.network(
                              TMDbService.getImageUrl(movie.backdropPath),
                              fit: BoxFit.cover,
                            )
                          : Container(color: Colors.grey[900]),
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
                    onPressed: () {},
                  ),
                ],
              ),

              // FILM INFÓK
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CÍM
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // MŰFAJOK & INFÓK
                      Row(
                        children: [
                          if (movie.voteAverage != null) ...[
                            _buildInfoChip(
                              '⭐ ${movie.voteAverage!.toStringAsFixed(1)}',
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (movie.releaseDate != null) ...[
                            _buildInfoChip(movie.releaseDate!.substring(0, 4)),
                            const SizedBox(width: 8),
                          ],
                          if (movie.runtime != null) ...[
                            _buildInfoChip('${movie.runtime!} perc'),
                          ],
                        ],
                      ),

                      const SizedBox(height: 16),

                      // MŰFAJOK
                      if (movie.genres != null && movie.genres!.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          children: movie.genres!
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

                      // TAGLINE
                      if (movie.tagline != null &&
                          movie.tagline!.isNotEmpty) ...[
                        Text(
                          '"${movie.tagline!}"',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // LEÍRÁS
                      if (movie.overview != null &&
                          movie.overview!.isNotEmpty) ...[
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
                          movie.overview!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
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

      // PLAY GOMB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Később trailer
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Trailer hamarosan...'),
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

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
