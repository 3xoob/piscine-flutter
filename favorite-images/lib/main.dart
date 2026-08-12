import 'package:flutter/material.dart';

import 'screens/gallery_page.dart';

void main() {
  runApp(const FavoriteImagesApp());
}

class FavoriteImagesApp extends StatelessWidget {
  const FavoriteImagesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Images',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pinkAccent,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2937),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      home: const GalleryPage(),
    );
  }
}

