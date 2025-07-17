# 🛍️ Wasel E-Commerce App

A modern Flutter-based e-commerce application with Firebase backend integration, featuring product listings, cart management, and user authentication.

## 📱 Features

- **User Authentication**
  - Email/Password login and registration
  - Google Sign-In
  - Guest checkout restriction
  - Protected routes

- **Product Browsing**
  - Product listings with images
  - Product details view
  - Search and filter functionality
  - Category-based navigation

- **Shopping Cart**
  - Add/remove items
  - Update quantities
  - Guest cart persistence
  - Secure checkout process

- **User Experience**
  - Responsive design
  - Smooth animations
  - Dark/Light theme support
  - Form validation

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)
- Android Studio / Xcode (for emulator/simulator)
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/AwaeshaHuss/Wasel_Task.git
   cd Wasel_Task
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android and iOS apps to your Firebase project
   - Download the configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS
   - Place these files in the appropriate directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Building APK/Release

### For Android

1. Configure signing
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Create `key.properties` in `android/` with:
   ```
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path-to-keystore>/upload-keystore.jks
   ```

3. Build the APK:
   ```bash
   flutter build apk --release
   ```
   
   Or build an app bundle:
   ```bash
   flutter build appbundle --release
   ```

4. Find the APK at:
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

### For iOS

1. Set up code signing in Xcode
2. Build the archive:
   ```bash
   flutter build ios --release
   ```
3. Open Xcode and archive the app

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── error/
│   ├── router/
│   ├── theme/
│   └── widgets/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── cart/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── product/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

## 🛠️ Dependencies

- `flutter_bloc`: State management
- `firebase_core`: Firebase integration
- `firebase_auth`: User authentication
- `cloud_firestore`: Cloud database
- `go_router`: Navigation and routing
- `cached_network_image`: Image caching
- `equatable`: Value equality
- `dartz`: Functional programming
- `intl`: Internationalization

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ✉️ Contact

For any questions or feedback, please contact [Your Email] or create an issue in the repository.

---

<div align="center">
  Made with ❤️ using Flutter
</div>
