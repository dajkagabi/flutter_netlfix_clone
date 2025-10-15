import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_screen.dart';

class MovieGridScreen extends StatelessWidget {
  final String categoryTitle;
  final List<Movie> movies;

  const MovieGridScreen({
    super.key,
    required this.categoryTitle,
    required this.movies,
  });

  // Navigáció a film részletei képernyőre
  void _navigateToMovieDetail(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(movieId: movie.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          categoryTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Vissza a főoldalra
        ),
        elevation: 0,
      ),
      body: _buildContent(),
    );
  }

  // A képernyő tartalmának összeállítása
  Widget _buildContent() {
    // Ha nincsenek filmek, üres állapotot jelenítünk meg
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.movie_filter_outlined,
              color: Colors.white54,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Nincsenek filmek',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A $categoryTitle kategóriában még nincsenek filmek',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Rács elrendezés a filmek megjelenítésére
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filmek számának megjelenítése
          Text(
            '${movies.length} film',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          // Filmek rácsos elrendezése
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 oszlop
                crossAxisSpacing: 16, // Tér az oszlopok között
                mainAxisSpacing: 16, // Tér a sorok között
                childAspectRatio: 0.65, // Képarány
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(
                  movie: movie,
                  onTap: () => _navigateToMovieDetail(context, movie),
                  width: 160,
                  height: 240,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
