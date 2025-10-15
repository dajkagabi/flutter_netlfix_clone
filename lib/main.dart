import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_netlfix_clone/providers/movie_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MovieProvider())],
      child: MaterialApp(
        title: 'Netflix Clone',
        theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
