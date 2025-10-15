import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';
import '../services/tmdb_service.dart';
import '../models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      movieProvider.loadAllMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'NETFLIX',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: const Text(
                    'Keresés',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Keresés hamarosan...',
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading && movieProvider.popularMovies.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  KIEMELT
                _buildFeaturedMovie(movieProvider),

                const SizedBox(height: 20),

                //  TRENDI
                SectionHeader(title: 'Trendi most', onSeeAll: () {}),
                _buildMovieList(movieProvider.trendingMovies),

                const SizedBox(height: 20),

                //  NÉPSZERŰ
                SectionHeader(title: 'Népszerű filmek', onSeeAll: () {}),
                _buildMovieList(movieProvider.popularMovies),

                const SizedBox(height: 20),

                //  LEGJOBBRA ÉRTÉKELT
                SectionHeader(title: 'Legjobbra értékelt', onSeeAll: () {}),
                _buildMovieList(movieProvider.topRatedMovies),

                const SizedBox(height: 20),

                //  MOST A MOZIKBAN
                SectionHeader(title: 'Most a mozikban', onSeeAll: () {}),
                _buildMovieList(movieProvider.nowPlayingMovies),

                const SizedBox(height: 20),

                //  HAMAROSAN
                SectionHeader(title: 'Hamarosan', onSeeAll: () {}),
                _buildMovieList(movieProvider.upcomingMovies),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedMovie(MovieProvider movieProvider) {
    if (movieProvider.nowPlayingMovies.isEmpty) {
      return Container(
        height: 500,
        color: Colors.grey[900],
        child: const Center(
          child: Text(
            'Nincs kiemelt film',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final featuredMovie = movieProvider.nowPlayingMovies.first;
    final backdropUrl = featuredMovie.backdropPath != null
        ? TMDbService.getImageUrl(featuredMovie.backdropPath)
        : null;

    return Container(
      height: 500,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        image: backdropUrl != null
            ? DecorationImage(
                image: NetworkImage(backdropUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                featuredMovie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(List<Movie> movies) {
    if (movies.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Nincsenek filmek',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCard(movie: movie);
        },
      ),
    );
  }
}
