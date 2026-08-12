import 'package:flutter/material.dart';

import '../models/place.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Place> places;
  final void Function(String id) onDelete;

  const FavoritesScreen({
    super.key,
    required this.places,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No favorite places yet',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return Dismissible(
            key: ValueKey(place.id),
            direction: DismissDirection.startToEnd,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (_) {
              onDelete(place.id);
            },
            child: ListTile(
              leading: const Icon(Icons.place),
              title: Text(place.name),
              subtitle: Text(place.address),
            ),
          );
        },
      ),
    );
  }
}

