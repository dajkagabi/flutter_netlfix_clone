import 'package:flutter/material.dart';
import 'package:flutter_netlfix_clone/screens/movie_detail_screen.dart';
import 'package:flutter_netlfix_clone/screens/search_screen.dart';
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading && movieProvider.popularMovies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Filmek betöltése...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          if (movieProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Hiba történt',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      movieProvider.error!,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      movieProvider.loadAllMovies();
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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKiemeltFilm(movieProvider),
                const SizedBox(height: 20),
                SectionHeader(title: 'Trendi most', onSeeAll: () {}),
                _buildFilmLista(movieProvider.trendingMovies),
                const SizedBox(height: 20),
                SectionHeader(title: 'Népszerű filmek', onSeeAll: () {}),
                _buildFilmLista(movieProvider.popularMovies),
                const SizedBox(height: 20),
                SectionHeader(title: 'Legjobbra értékelt', onSeeAll: () {}),
                _buildFilmLista(movieProvider.topRatedMovies),
                const SizedBox(height: 20),
                SectionHeader(title: 'Most a mozikban', onSeeAll: () {}),
                _buildFilmLista(movieProvider.nowPlayingMovies),
                const SizedBox(height: 20),
                SectionHeader(title: 'Hamarosan', onSeeAll: () {}),
                _buildFilmLista(movieProvider.upcomingMovies),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKiemeltFilm(MovieProvider movieProvider) {
    if (movieProvider.nowPlayingMovies.isEmpty) {
      return Container(
        height: 500,
        color: Colors.grey[900],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie_outlined, color: Colors.white54, size: 64),
              SizedBox(height: 16),
              Text(
                'Nincs kiemelt film',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    final kiemeltFilm = movieProvider.nowPlayingMovies.first;
    final backdropUrl = kiemeltFilm.backdropPath != null
        ? TMDbService.getImageUrl(kiemeltFilm.backdropPath)
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
                kiemeltFilm.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 20.0),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailScreen(movieId: kiemeltFilm.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Lejátszás'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailScreen(movieId: kiemeltFilm.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('További információ'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilmLista(List<Movie> filmek) {
    if (filmek.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.movie_creation_outlined,
                color: Colors.white54,
                size: 48,
              ),
              SizedBox(height: 8),
              Text('Nincsenek filmek', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: filmek.length,
        itemBuilder: (context, index) {
          final film = filmek[index];
          return MovieCard(movie: film);
        },
      ),
    );
  }
}
