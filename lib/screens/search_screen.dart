import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    _searchProvider = Provider.of<SearchProvider>(context, listen: false);

    // Fókusz a keresőmezőre az oldal megnyitásakor
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    _searchProvider.searchMovies(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Filmek keresése...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              suffixIcon: Icon(Icons.search, color: Colors.white54),
            ),
            onChanged: _performSearch,
            onSubmitted: _performSearch,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          // Keresés folyamatban
          if (searchProvider.isSearching) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.red),
                  SizedBox(height: 16),
                  Text('Keresés...', style: TextStyle(color: Colors.white)),
                ],
              ),
            );
          }

          // Hiba esetén
          if (searchProvider.searchError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Hiba történt',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    searchProvider.searchError!,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _performSearch(_searchController.text);
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

          // Üres keresés
          if (searchProvider.searchQuery.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, color: Colors.white54, size: 80),
                  SizedBox(height: 16),
                  Text(
                    'Keress filmeket',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Írd be a film címét a kereséshez',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            );
          }

          // Nincs találat
          if (searchProvider.searchResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, color: Colors.white54, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    'Nincs találat a "${searchProvider.searchQuery}" kifejezésre',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Próbálj meg másik kifejezést',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            );
          }

          // Találatok megjelenítése
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Találatok: ${searchProvider.searchResults.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.6,
                        ),
                    itemCount: searchProvider.searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = searchProvider.searchResults[index];
                      return MovieCard(movie: movie);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
