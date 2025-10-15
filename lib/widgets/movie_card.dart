// widgets/movie_card.dart
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final double width;
  final double height;

  const MovieCard({
    Key? key,
    required this.movie,
    required this.onTap,
    //Méretek, rácsok
    this.width = 130,
    this.height = 190,
  }) : super(key: key);

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
            // KÉP RESZORT
            _buildMoviePoster(),
            const SizedBox(height: 6),
            // CÍM ÉS INFÓ
            _buildMovieInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviePoster() {
    return Container(
      width: width,
      height: height - 50, // LEVONVA AZ INFO RÉSZ MAGASSÁGÁT
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
            // HÁTTÉRKÉP
            _buildPosterImage(),
            // ÁTTETSŐ ÁRNYEÉK A ALJÁRA
            _buildImageOverlay(),
            // ÉRTÉKELÉS
            if (movie.hasRating) _buildRatingBadge(),
          ],
        ),
      ),
    );
  }

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
        //overlay átszabása
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
          // CÍM
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
          // ÉV ÉS MŐFAJ
          _buildMovieMeta(),
        ],
      ),
    );
  }

  Widget _buildMovieMeta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ÉV
        if (movie.releaseDate != null && movie.releaseDate!.isNotEmpty)
          Text(
            movie.releaseDate!.length >= 4
                ? movie.releaseDate!.substring(0, 4)
                : movie.releaseDate!,
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 9),
          ),
      ],
    );
  }
}
