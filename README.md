# Campus Bites

Campus Bites is a Flutter mobile application for browsing restaurants, viewing menus, managing a cart, placing food orders, and tracking order history. The app uses Firebase for authentication and data storage, with Google Maps support for location-based ordering.

## Features

- Restaurant and menu browsing
- Food categories, item details, sizes, and add-ons
- Cart management with local persistence
- Phone, Google, and anonymous authentication flows
- Address selection and location support with Google Maps
- Order placement and order history
- Manager-facing restaurant/order management screens
- Firebase Realtime Database and Firestore integration

## Tech Stack

- Flutter / Dart
- Firebase Core, Auth, Realtime Database, Firestore
- GetX for state management and navigation
- GetStorage for local cart/session storage
- Google Maps Flutter
- Google Sign-In
- Lottie animations

## Project Structure

```text
lib/
  controller/      Shared controllers
  firebase/        Firebase reference helpers
  model/           Data models
  screens/         App screens and flows
  state/           GetX state controllers
  strings/         UI text constants
  utils/           Utility helpers
  view_model/      View model layer
  widgets/         Reusable UI widgets

assets/
  animation/       Lottie and visual assets
  images/          App images and icons
```

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- Dart SDK
- Android Studio or Xcode
- Firebase project
- Google Maps API key

### Installation

1. Clone the repository.

```bash
git clone https://github.com/your-username/campus-bites.git
cd campus-bites
```

2. Install dependencies.

```bash
flutter pub get
```

3. Add Firebase configuration.

- Android: add your own `android/app/google-services.json`
- iOS: add your own `ios/Runner/GoogleService-Info.plist` if enabling iOS Firebase
- Web: configure Firebase options in the app entry point or generate `firebase_options.dart`

4. Add your Google Maps API key where the app reads map configuration.

5. Run the app.

```bash
flutter run
