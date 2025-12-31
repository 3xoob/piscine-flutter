# Secure Notes Package Workspace

This folder contains:

- `note/` – a Flutter/Dart package that provides a `Note` model and a SQLite `Database` helper with CRUD operations.
- `secure_notes/` – a simple Flutter app that uses the `note` package.

## 1. `note` Package

The `note` package is a reusable library designed for a Secure Notes app. It exposes:

- `Note` model (in `lib/src/note_model.dart`)
  - Fields: `int? id`, `String title`, `String body`, `String date`.
  - Supports `toMap()` / `fromMap()` for SQLite.
- `Database` helper (in `lib/src/database.dart`)
  - Uses `sqflite`, `path`, and `path_provider`.
  - Methods:
    - `Future<void> create()`
    - `Future<List<Note>> getAllNotes()`
    - `Future<void> deleteAllNotes()`
    - `Future<Note> addNote({required Note note})`
    - `Future<int> deleteNote({required Note note})`
    - `Future<int> updateNote({required Note oldNote, required Note newNote})`

Public API is exported from `lib/note.dart`, so consumers can simply do:

```dart
import 'package:note/note.dart';
```

### Using `note` as a local dependency

In another Flutter app located alongside this folder, add to `pubspec.yaml`:

```yaml
dependencies:
  note:
    path: ./package/note
```

Then run `flutter pub get`.

## 2. `secure_notes` App

`secure_notes/` is a minimal Flutter app that demonstrates how to use the `note` package.

Key points:

- Depends on the local `note` package via:

  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    cupertino_icons: ^1.0.8
    note:
      path: ../note
  ```

- `lib/main.dart`:
  - Calls `WidgetsFlutterBinding.ensureInitialized();`.
  - Creates a `Database` instance and calls `create()`.
  - Loads notes with `getAllNotes()` and displays them in a simple `ListView`.

### Running the app

From the repository root:

```bash
cd package/secure_notes
flutter pub get
flutter run
```

This will launch the Secure Notes app that uses the shared `note` package.

