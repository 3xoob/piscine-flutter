# piscine-flutter

A personal collection of Dart and Flutter exercises completed during a "piscine" (an intensive, project-based bootcamp track), progressing from core Dart language fundamentals to a small two-package Flutter workspace built around local note storage.

## Overview

The repository is organized in two layers:

- A set of standalone `.dart` files at the repository root, each covering a single Dart language concept (variables, functions, classes, collections).
- A `package/` workspace containing two related Flutter/Dart projects: a reusable `note` package and a `secure_notes` app that is meant to consume it.

The `note` package's `pubspec.yaml` points its `homepage` field at `https://learn.reboot01.com/git/aabdulhu/package`, indicating this work originates from the Reboot01 (42 Network) curriculum.

## Features

Confirmed by the source in this repository:

- **Dart fundamentals scripts** — printing output, typed/`const` variables, positional/optional/named function parameters, classes with constructors and getters, single inheritance with a private field, and `List`/`Set`/`Map` collection literals (see [Project Structure](#project-structure) below for the full file list).
- **`note` package** (`package/note`) — a `Note` model (`id`, `title`, `body`, `date`) with `copyWith`, `toMap`, and `fromMap`, plus a `Database` helper built on `sqflite` that creates a SQLite table and provides `create()`, `getAllNotes()`, `deleteAllNotes()`, `addNote()`, `deleteNote()`, `updateNote()`, and `close()`.
- **`secure_notes` app** (`package/secure_notes`) — a Flutter application project. In its current state it contains only the unmodified default `flutter create` counter-demo screen (`MyApp` / `MyHomePage` with an increment counter); its `pubspec.yaml` does not declare a dependency on the `note` package and `lib/main.dart` does not import or use it.

## Technologies

- **Dart**
- **Flutter**
- Packages used by `package/note`: `sqflite ^2.3.0`, `path ^1.9.0`, `path_provider ^2.1.0`
- Packages used by `package/secure_notes`: `cupertino_icons ^1.0.8`
- Dev dependencies: `flutter_test`, `flutter_lints ^6.0.0` (in `secure_notes`)

## Project Structure

```
piscine-flutter/
├── intro.dart                    # Hello-world entry point (only file with main())
├── variables.dart                # Typed and const variable declarations
├── plain-sum.dart                # Function with positional parameters
├── optional-sum.dart              # Function with an optional positional parameter
├── named-optional-sum.dart        # Function with optional named parameters
├── named-required-sum.dart        # Function with required named parameters
├── max-num.dart                   # Function computing the max of three numbers
├── circle.dart                    # Circle class with area/perimeter/bounds getters
├── person.dart                    # Person class with an optional positional field
├── student.dart                   # Student extends Person, private field + getter
├── university.dart                # University class with private fields and getters
├── data-structures.dart           # List, Set, and Map literals
├── COPYRIGHT.md
├── LICENSE
├── package/
│   ├── README.md                  # Notes on the note / secure_notes workspace
│   ├── note/                      # Flutter package (library)
│   │   ├── pubspec.yaml
│   │   └── lib/
│   │       ├── note.dart          # Public exports
│   │       └── src/
│   │           ├── note_model.dart
│   │           └── database.dart
│   └── secure_notes/               # Flutter app
│       ├── pubspec.yaml
│       └── lib/main.dart
└── bizz-card/, bloc-counter/, bouncer/, favorite-images/,
    map-markers/, movie-list/, quizz-app/
```

The root-level `.dart` files are individual exercises with no shared entry point (only `intro.dart` defines `main()`); the rest declare functions or classes meant to be read/imported rather than run directly.

The directories `bizz-card`, `bloc-counter`, `bouncer`, `favorite-images`, `map-markers`, `movie-list`, and `quizz-app` are recorded in git as submodule (gitlink) references, but no `.gitmodules` file registers them. As a result they check out as empty directories — their source is not present in this repository. Their names suggest further Flutter exercises (a business-card layout, a BLoC-based counter, an age/bouncer check, an image gallery, map markers, a movie list, and a quiz app), but this cannot be confirmed from the current checkout.

## Requirements

- `package/note` (`pubspec.yaml`): Dart SDK `>=3.0.0 <4.0.0`; its lockfile resolves against Flutter `>=3.35.0`.
- `package/secure_notes` (`pubspec.yaml`): Dart SDK `^3.10.1`; its lockfile resolves against Flutter `>=3.18.0-18.0.pre.54`.
- The root-level `.dart` files only require a Dart SDK capable of running plain scripts.

## Installation

For the Flutter package/app pair:

```bash
cd package/note
flutter pub get

cd ../secure_notes
flutter pub get
```

## Usage

Run the only executable root-level script:

```bash
dart run intro.dart
```

The other root-level `.dart` files (e.g. `circle.dart`, `student.dart`, `data-structures.dart`) do not have a `main()` function; they are standalone declarations meant to be opened and read, or imported from another script/test.

Run the `secure_notes` Flutter app:

```bash
cd package/secure_notes
flutter run
```

Note that, as shipped, this launches the default Flutter counter demo rather than a note-taking UI (see [Features](#features)).

## Configuration

No environment variables, `.env` files, or external service configuration are used by any project in this repository.

## Example

Using the `note` package's API directly, as implemented in `package/note/lib/src/database.dart` and `note_model.dart`:

```dart
import 'package:note/note.dart';

final db = Database();
await db.create();

final saved = await db.addNote(
  note: Note(title: 'Groceries', body: 'Milk, eggs, bread', date: '2026-07-14'),
);

final notes = await db.getAllNotes();
```

## Learning Objectives

Based on the exercises present in this repository:

- Dart syntax basics: printing, typed variables, and `const` values.
- Function parameter styles: positional, optional positional, and named (both optional and required).
- Object-oriented Dart: classes, constructors, getters, private fields (`_name`), and single-level inheritance (`Student extends Person`).
- Core collection types: `List`, `Set`, and `Map`, including nested lists.
- Structuring a reusable Flutter package (`note`) with an internal `src/` folder and a single export file (`note.dart`).
- Using `sqflite` with `path_provider` to persist model data locally, and wiring a package as a local `path:` dependency for another Flutter project.

## Limitations

- Seven top-level directories (`bizz-card`, `bloc-counter`, `bouncer`, `favorite-images`, `map-markers`, `movie-list`, `quizz-app`) are broken git submodule links with no `.gitmodules` entry; they contain no files in this checkout.
- `package/secure_notes` does not yet depend on or use the `note` package: its `pubspec.yaml` lists no such dependency, and `lib/main.dart` is the unmodified Flutter counter-demo template.
- No automated tests are present anywhere in the repository.
- No CI configuration is present in the repository.

## License

This repository includes a `LICENSE` file (and a matching `COPYRIGHT.md`) stating that all rights are reserved by the copyright holder, and that the source is made publicly available for portfolio and viewing purposes only — no permission is granted to copy, modify, distribute, or reuse the code without prior written permission.
