import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'movie_card.dart';

class MovieGridView extends StatelessWidget {
  final List<Movie> movies;
  final String? title;
  final VoidCallback? onSeeAll;
  final Function(Movie) onMovieTap;

  const MovieGridView({
    super.key,
    required this.movies,
    this.title,
    this.onSeeAll,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) _buildSectionHeader(),
        const SizedBox(height: 16),
        _buildGrid(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text(
                'Összes',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return SizedBox(
      height: 230, // Fix magasság a vízszintes gridhez
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCard(
            movie: movie,
            onTap: () => onMovieTap(movie),
            width: 140,
            height: 210,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_filter_outlined, color: Colors.white54, size: 40),
            SizedBox(height: 8),
            Text(
              'Nincsenek filmek',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
