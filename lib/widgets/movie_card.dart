import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../providers/favorites_provider.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final double width;
  final double height;
  final bool showFavoriteIcon;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    //Méretek
    this.width = 130,
    this.height = 190,
    this.showFavoriteIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMoviePoster(context),
            const SizedBox(height: 6),
            _buildMovieInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviePoster(BuildContext context) {
    return Container(
      width: width,
      height: height - 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            _buildPosterImage(),
            _buildImageOverlay(),
            if (movie.hasRating) _buildRatingBadge(),
            if (showFavoriteIcon) _buildFavoriteIcon(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteIcon(BuildContext context) {
    return Positioned(
      top: 6,
      left: 6,
      child: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final isFavorite = favoritesProvider.isFavorite(movie);
          return GestureDetector(
            onTap: () {
              favoritesProvider.toggleFavorite(movie);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white,
                size: 16,
              ),
            ),
          );
        },
      ),
    );
  }

  //
  Widget _buildPosterImage() {
    if (!movie.hasPoster) {
      return _buildPlaceholder();
    }

    return Image.network(
      TMDbService.getImageUrl(movie.posterPath),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.white54,
          size: 36,
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2),
      ),
    );
  }

  Widget _buildImageOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Positioned(
      top: 6,
      right: 6,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 10),
            const SizedBox(width: 2),
            Text(
              movie.voteAverage!.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfo() {
    return SizedBox(
      height: 44,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          if (movie.releaseDate != null && movie.releaseDate!.isNotEmpty)
            Text(
              movie.releaseDate!.length >= 4
                  ? movie.releaseDate!.substring(0, 4)
                  : movie.releaseDate!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 9,
              ),
            ),
        ],
      ),
    );
  }
}
