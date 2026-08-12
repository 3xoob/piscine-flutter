# Movie List App

A Flutter app that loads movie data from a JSON file, displays a list of top-rated movies, and shows detailed information about each movie.

## Features

- Loads movies from a local JSON file in `assets/movies.json`
- Home page shows movies sorted by IMDb rating (descending)
- ListView with each movie's poster, title, genre, and rating
- Tapping a movie opens a detailed page with:
  - Poster image
  - Year
  - Genre
  - Director
  - Actors
  - Runtime
  - IMDb rating
  - Plot
- Search bar to filter movies by title (case-insensitive substring search, similar to SQL `ILIKE`)
- Back navigation from detail page via AppBar back button

## Important Files

- `lib/models/movie.dart` – `Movie` model and `fromJson` factory
- `lib/screens/movie_list_page.dart` – Home page with search bar and movie list (uses `FutureBuilder`)
- `lib/screens/movie_detail_page.dart` – Detailed movie information page
- `lib/main.dart` – App entry point and theme
- `assets/movies.json` – Static movie data
- `pubspec.yaml` – Flutter config and assets registration

## How to Run

From the project root:

```bash
cd movie-list
flutter pub get
flutter run
```

Make sure you have Flutter installed and an emulator or physical device connected.

