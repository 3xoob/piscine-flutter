import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/place.dart';

const String kGoogleApiKey = 'AIzaSyBD2weoYPwtn1IFVgQTvRnv4tJvOuOMSeE';

class MapScreen extends StatefulWidget {
  final List<Place> places;
  final void Function(Place place) onAddPlace;

  const MapScreen({
    super.key,
    required this.places,
    required this.onAddPlace,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final List<_PlaceSuggestion> _suggestions = [];
  bool _isSearching = false;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco as a default
    zoom: 11,
  );

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Set<Marker> get _markers {
    return widget.places
        .map(
          (place) => Marker(
            markerId: MarkerId(place.id),
            position: LatLng(place.latitude, place.longitude),
            infoWindow: InfoWindow(
              title: place.name,
              snippet: place.address,
            ),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(place.name),
                  content: Text(place.address),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        )
        .toSet();
  }

  Future<void> _goToCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied.'),
        ),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final target = LatLng(position.latitude, position.longitude);
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 14),
      ),
    );
  }

  Future<void> _searchPlaces(String input) async {
    if (input.isEmpty || kGoogleApiKey == 'YOUR_GOOGLE_MAPS_API_KEY_HERE') {
      return;
    }

    setState(() {
      _isSearching = true;
      _suggestions.clear();
    });

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': input,
        'key': kGoogleApiKey,
        'types': 'geocode',
      },
    );

    final response = await http.get(uri);
    if (!mounted) return;

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final status = data['status'] as String? ?? 'UNKNOWN_ERROR';

      if (status == 'OK') {
        final predictions = data['predictions'] as List<dynamic>;
        setState(() {
          _suggestions.addAll(
            predictions.map(
              (p) => _PlaceSuggestion(
                description: p['description'] as String,
                placeId: p['place_id'] as String,
              ),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Places search failed: $status')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Places search HTTP error: ${response.statusCode}')),
      );
    }

    setState(() {
      _isSearching = false;
    });
  }

  Future<void> _goToSuggestion(_PlaceSuggestion suggestion) async {
    if (kGoogleApiKey == 'YOUR_GOOGLE_MAPS_API_KEY_HERE') return;

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': suggestion.placeId,
        'fields': 'name,geometry/location,formatted_address',
        'key': kGoogleApiKey,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return;

    final data = json.decode(response.body) as Map<String, dynamic>;
    final status = data['status'] as String? ?? 'UNKNOWN_ERROR';
    if (status != 'OK') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Place details failed: $status')),
      );
      return;
    }

    final result = data['result'] as Map<String, dynamic>;
    final location = result['geometry']['location'] as Map<String, dynamic>;

    final name = result['name'] as String;
    final address = result['formatted_address'] as String;
    final lat = (location['lat'] as num).toDouble();
    final lng = (location['lng'] as num).toDouble();

    final target = LatLng(lat, lng);

    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 15),
      ),
    );

    // Also add as a favorite place so it appears as a marker and in the list.
    widget.onAddPlace(
      Place(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        address: address,
        latitude: lat,
        longitude: lng,
      ),
    );

    setState(() {
      _suggestions.clear();
      _searchController.text = name;
    });
  }

  Future<void> _addPlaceAt(LatLng position) async {
    final titleController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add favorite place'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Place name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, titleController.text.trim());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    final place = Place(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: result,
      address: 'Custom place',
      latitude: position.latitude,
      longitude: position.longitude,
    );

    widget.onAddPlace(place);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search places',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _suggestions.clear();
                          });
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onSubmitted: _searchPlaces,
            ),
          ),
          if (_suggestions.isNotEmpty)
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    leading: const Icon(Icons.place),
                    title: Text(suggestion.description),
                    onTap: () => _goToSuggestion(suggestion),
                  );
                },
              ),
            ),
          Expanded(
            child: kIsWeb
                ? const Center(
                    child: Text(
                      'Google Maps is only fully supported on Android/iOS for this exercise.\n'
                      'Please run the app on a mobile device or emulator.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: _initialCameraPosition,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        markers: _markers,
                        onMapCreated: (controller) {
                          _mapController = controller;
                        },
                        onLongPress: _addPlaceAt,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _PlaceSuggestion {
  final String description;
  final String placeId;

  _PlaceSuggestion({
    required this.description,
    required this.placeId,
  });
}
