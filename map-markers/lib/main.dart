import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/place.dart';
import 'screens/favorites_screen.dart';
import 'screens/info_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const MapMarkersApp());
}

class MapMarkersApp extends StatelessWidget {
  const MapMarkersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Markers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Place> _places = [];
  bool _isLoading = true;

  static const String _prefsKey = 'favorite_places';

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);
    if (jsonString != null) {
      final List<dynamic> data = json.decode(jsonString) as List<dynamic>;
      _places
        ..clear()
        ..addAll(
          data
              .map(
                (item) =>
                    Place.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
        );
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _savePlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(
      _places.map((p) => p.toJson()).toList(),
    );
    await prefs.setString(_prefsKey, jsonString);
  }

  void _addPlace(Place place) {
    setState(() {
      _places.add(place);
    });
    _savePlaces();
  }

  void _deletePlace(String id) {
    setState(() {
      _places.removeWhere((p) => p.id == id);
    });
    _savePlaces();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Map Markers'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map), text: 'Map'),
              Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
              Tab(icon: Icon(Icons.info), text: 'Info'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            MapScreen(
              places: _places,
              onAddPlace: _addPlace,
            ),
            FavoritesScreen(
              places: _places,
              onDelete: _deletePlace,
            ),
            const InfoScreen(),
          ],
        ),
      ),
    );
  }
}
