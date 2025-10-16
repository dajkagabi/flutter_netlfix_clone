import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';
import '../services/tmdb_service.dart';
import '../models/movie.dart';
import 'movie_detail_screen.dart';
import 'movie_grid_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Amikor a widget megjelenik, azonnal betöltjük a filmeket
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      movieProvider.loadAllMovies();
    });
  }

  @override
  void dispose() {
    // Takarítás: scroll controller felszabadítás
    /*Megakadályozza a memóriaszivárgást
     Leállítja az eseményfigyelőket
    Felszabadítja a rendszererőforrásokat  */
    _scrollController.dispose();
    super.dispose();
  }

  // Egy film részleteinek megtekintése
  void _navigateToMovieDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailScreen(movieId: movie.id),
      ),
    );
  }

  // Egy kategória összes filmjének megtekintése
  void _navigateToCategory(String title, List<Movie> movies) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MovieGridScreen(categoryTitle: title, movies: movies),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Most már a MAINCREEN kezeli
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          // Betöltés állapot
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

          //Hibaüzenet megjelenítése
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
                  // Újrapróbálás gomb
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

          //Filmek megjelenítése
          return SingleChildScrollView(
            controller: _scrollController,
            // Rugalmas görgetés
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kiemelt film a tetején
                _buildKiemeltFilm(movieProvider),
                const SizedBox(height: 20),

                // Trendi filmek
                SectionHeader(
                  title: 'Trendi most',
                  onSeeAll: () => _navigateToCategory(
                    'Trendi filmek',
                    movieProvider.trendingMovies,
                  ),
                ),
                _buildFilmLista(movieProvider.trendingMovies),
                const SizedBox(height: 20),

                // Népszerű filmek
                SectionHeader(
                  title: 'Népszerű filmek',
                  onSeeAll: () => _navigateToCategory(
                    'Népszerű filmek',
                    movieProvider.popularMovies,
                  ),
                ),
                _buildFilmLista(movieProvider.popularMovies),
                const SizedBox(height: 20),

                // Legjobbra értékelt filmek
                SectionHeader(
                  title: 'Legjobbra értékelt',
                  onSeeAll: () => _navigateToCategory(
                    'Legjobbra értékelt filmek',
                    movieProvider.topRatedMovies,
                  ),
                ),
                _buildFilmLista(movieProvider.topRatedMovies),
                const SizedBox(height: 20),

                // Most a mozikban
                SectionHeader(
                  title: 'Most a mozikban',
                  onSeeAll: () => _navigateToCategory(
                    'Most a mozikban',
                    movieProvider.nowPlayingMovies,
                  ),
                ),
                _buildFilmLista(movieProvider.nowPlayingMovies),
                const SizedBox(height: 20),

                // Hamarosan érkező filmek
                SectionHeader(
                  title: 'Hamarosan',
                  onSeeAll: () => _navigateToCategory(
                    'Hamarosan érkező filmek',
                    movieProvider.upcomingMovies,
                  ),
                ),
                _buildFilmLista(movieProvider.upcomingMovies),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // Kiemelt film megjelenítése a képernyő tetején
  Widget _buildKiemeltFilm(MovieProvider movieProvider) {
    final nowPlayingMovies = movieProvider.nowPlayingMovies;

    // Ha nincsenek filmek, placeholder-t jelenítünk meg
    if (nowPlayingMovies.isEmpty) {
      return Container(
        height: 450,
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

    // Az első "most a mozikban" filmet használjuk kiemeltként
    final kiemeltFilm = nowPlayingMovies.first;
    final backdropUrl =
        kiemeltFilm.backdropPath != null && kiemeltFilm.backdropPath!.isNotEmpty
        ? TMDbService.getImageUrl(kiemeltFilm.backdropPath)
        : null;

    return GestureDetector(
      onTap: () => _navigateToMovieDetail(kiemeltFilm),
      child: Container(
        height: 450,
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
          // Áttetső átmenet a szöveg olvashatósága érdekében
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
              // Film címe
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  kiemeltFilm.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  //ha túl hosszú lenne a
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  bottom: 20.0,
                  right: 16.0,
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    // Lejátszás gomb
                    ElevatedButton.icon(
                      onPressed: () {
                        _navigateToMovieDetail(kiemeltFilm);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Lejátszás'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                    // Részletek gomb
                    OutlinedButton.icon(
                      onPressed: () {
                        _navigateToMovieDetail(kiemeltFilm);
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Részletek'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: Colors.white,
                        ), // Fehér keret
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Vízszintes film lista
  Widget _buildFilmLista(List<Movie> filmek) {
    // Ha nincsenek filmek, placeholder-t jelenítünk meg
    if (filmek.isEmpty) {
      return const SizedBox(
        height: 180,
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

    // Vízszintes görgethető lista
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: filmek.length,
        itemBuilder: (context, index) {
          final film = filmek[index];
          return MovieCard(
            movie: film,
            onTap: () => _navigateToMovieDetail(film),
            width: 130,
            height: 190,
          );
        },
      ),
    );
  }
}
