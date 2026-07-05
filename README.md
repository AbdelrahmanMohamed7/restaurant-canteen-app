# Restaurant Canteen App

A Flutter restaurant and canteen ordering app with Firebase authentication, realtime restaurant/menu data, cart management, location-aware checkout, and order tracking.

This repository is structured as a portfolio-ready mobile app project. It does not include private Firebase or Google Maps credentials, so each developer should connect their own Firebase project before running the full backend-powered flow.

## Features

- Browse restaurants and restaurant details
- View menu categories, popular items, and best deals
- Open food details with size and add-on options
- Add, update, and remove cart items
- Persist cart state locally with GetStorage
- Select addresses and use location/map features
- Place orders and view order history
- Support customer and manager-facing screens
- Firebase Authentication, Realtime Database, and Firestore integration

## Tech Stack

- Flutter 3.x and Dart
- Firebase Core, Auth, Realtime Database, and Firestore
- GetX for navigation and state management
- GetStorage for local persistence
- Google Maps Flutter and Location
- Google Sign-In
- Lottie animations
- Android Gradle Plugin 8.3.2
- Kotlin 1.9.22
- Gradle 8.4

## Project Structure

```text
lib/
  controller/      Shared controllers
  firebase/        Firebase database/reference helpers
  model/           Data models
  screens/         App screens and user flows
  state/           GetX state controllers
  strings/         UI text constants
  utils/           Utility helpers
  view_model/      View model layer
  widgets/         Reusable UI widgets

assets/
  animation/       Lottie and visual assets
  images/          App images and icons

android/           Android project configuration
ios/               iOS project configuration
test/              Flutter widget tests
```

## Requirements

- Flutter SDK 3.x
- Dart SDK
- Android Studio or VS Code with Flutter/Dart extensions
- Android emulator or physical Android device
- Firebase project
- Google Maps API key

## Getting Started

Clone the repository:

```bash
git clone https://github.com/AbdelrahmanMohamed7/restaurant-canteen-app.git
cd restaurant-canteen-app
```

Install packages:

```bash
flutter pub get
```

Add your private Firebase Android config:

```text
android/app/google-services.json
```

This file is intentionally ignored by Git and should not be committed.

Run the app:

```bash
flutter devices
flutter run
```

To run on a specific emulator:

```bash
flutter run -d emulator-5554
```

## Firebase Setup

Create a Firebase project and enable the services used by the app:

- Firebase Authentication
- Realtime Database
- Cloud Firestore

Then download your Android `google-services.json` file from Firebase Console and place it here:

```text
android/app/google-services.json
```

The app expects restaurant, category, menu item, user, address, and order data to exist in Firebase.

## Google Maps Setup

The app uses Google Maps and location features. Add your own Google Maps API key in the app configuration before using map-based screens.

For public repositories, restrict API keys in Google Cloud Console and avoid committing any credential files.

## Useful Commands

Install dependencies:

```bash
flutter pub get
```

Run analysis without failing on existing style warnings:

```bash
flutter analyze --no-fatal-infos --no-fatal-warnings
```

Build Android debug APK:

```bash
flutter build apk --debug --target-platform android-arm64
```

Clean generated files:

```bash
flutter clean
flutter pub get
```

## Security Notes

The repository intentionally excludes:

```text
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
lib/firebase_options.dart
android/local.properties
*.jks
*.keystore
```

Keep Firebase files, signing keys, API keys, and local SDK paths private.

## Status

Verified locally with:

```text
Flutter 3.32.0
Android emulator API 35
Android debug APK build
```

## License

Add a license file if you want to define reuse terms for this project.
