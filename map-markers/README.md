# Map Markers App

A Flutter app that shows favorite places on a Google Map, allows searching via Google Places, and persists favorites between sessions.

## Features (as required)

- **TabBar with three screens**
  - **Map** – Google Map with favorite place markers and a search bar.
  - **Favorites** – List of favorite places with swipe-to-delete.
  - **Info** – Authors, emails, year, and app description.

- **Map screen**
  - Displays favorite places as markers with info windows.
  - Tapping a marker opens a dialog showing the place name and address.
  - Long-press on the map to add a new favorite place at that location.
  - Button to navigate to the user's current location (using `geolocator`).
  - Search bar using Google Places Autocomplete API:
    - Shows suggestions for addresses/places.
    - Tapping a suggestion moves the map to that location.

- **Favorites screen**
  - Shows list of saved favorite places.
  - Swipe right (dismiss) to delete a place from favorites.

- **Info screen**
  - Static info about the app and its authors (edit with your details).

## Important Files

- `lib/main.dart` – App entry point, `HomePage` with `TabBar`, state + persistence for favorite places.
- `lib/models/place.dart` – `Place` model with JSON serialization.
- `lib/screens/map_screen.dart` – Google Map, markers, search bar, current location button, add-place dialog.
- `lib/screens/favorites_screen.dart` – List of favorites with swipe-to-delete.
- `lib/screens/info_screen.dart` – App and author information.
- `pubspec.yaml` – Declares `google_maps_flutter`, `geolocator`, `shared_preferences`, and `http`.

## Setup: Google Maps & Places API Key

1. Create a Google Cloud project and enable:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Places API**
2. Create an API key and restrict it to these APIs.
3. Put your API key:
   - In the native Android/iOS config for `google_maps_flutter` (see package docs).
   - In `lib/screens/map_screen.dart` by replacing:

   ```dart
   const String kGoogleApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';
   ```

## Android Permissions

In `android/app/src/main/AndroidManifest.xml` add:

```xml
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

And configure your Google Maps API key as described in the `google_maps_flutter` documentation.

## iOS Permissions

In `ios/Runner/Info.plist` add:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We use your location to show it on the map.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>We use your location to show it on the map.</string>
```

Also configure the Maps API key in `AppDelegate` or `Info.plist` following `google_maps_flutter` setup instructions.

## How to Run

From the project root:

```bash
cd map-markers
flutter pub get
flutter run
```

Run on Android/iOS with proper API keys configured to see the map, current location, and Places search in action.

