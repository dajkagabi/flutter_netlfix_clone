import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movieId: movie.id),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Film poszter
            Container(
              height: 160,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: movie.posterPath != null
                    ? Image.network(
                        TMDbService.getImageUrl(movie.posterPath!),
                        fit: BoxFit.cover,
                        width: 120,
                        height: 160,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      )
                    : _buildPlaceholder(),
              ),
            ),
            const SizedBox(height: 8),

            // Film cím
            Text(
              movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Értékelés
            if (movie.voteAverage != null && movie.voteAverage! > 0) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.yellow, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    movie.voteAverage!.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Icon(Icons.movie, color: Colors.white54, size: 40),
      ),
    );
  }
}
