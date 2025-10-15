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
            Container(
              height: 160,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildPosterImage(),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              movie.title.isNotEmpty ? movie.title : 'Cím nem elérhető',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

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
            ] else ...[
              const SizedBox(height: 4),
              const Text(
                'Értékelés: N/A',
                style: TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPosterImage() {
    if (movie.posterPath == null || movie.posterPath!.isEmpty) {
      return _buildPlaceholder();
    }

    return Image.network(
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
            child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_creation_outlined,
              color: Colors.white54,
              size: 40,
            ),
            SizedBox(height: 4),
            Text(
              'Nincs kép',
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
