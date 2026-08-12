# Favorite Images App

A Flutter app that lets you build a personal gallery by taking photos with the camera or picking them from the device gallery, then viewing them in a grid and zooming into each image.

## Features

- AppBar with an `IconButton` to add images
- Bottom sheet with two options when adding:
  - Open camera
  - Open gallery
- Uses `image_picker` to access camera and gallery (Android & iOS)
- Shows a **"No images selected"** message when the collection is empty
- Selected images are added to a `GridView` gallery
- Tap an image to open a full-screen view
- Full-screen view supports pinch-to-zoom and pan via `InteractiveViewer`

## Important Files

- `lib/main.dart` – App entry point, theme, and `MaterialApp`
- `lib/screens/gallery_page.dart` – Main gallery screen with:
  - Image picking via `image_picker`
  - "No images selected" state
  - Grid of selected images
  - Navigation to full image view
- `lib/screens/image_detail_page.dart` – Full-screen zoomable image view
- `pubspec.yaml` – Declares `image_picker` dependency

## iOS Camera / Gallery Permissions

On a real Flutter project with iOS support, you must add the following keys to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take photos.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to pick images.</string>
```

## How to Run

From the project root:

```bash
cd favorite-images
flutter pub get
flutter run
```

Use a real device or emulator with a camera to test photo capture; gallery selection works in most simulators as well.

