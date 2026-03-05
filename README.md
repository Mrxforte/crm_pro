# CRM Pro 🚀

A modern and intuitive **Customer Relationship Management (CRM)** mobile application built with Flutter and Firebase. Manage your customers, track interactions, and streamline your business operations on the go.

---

## ✨ Features

- 🔐 **Secure Authentication** - Email/password authentication with Firebase
- 📝 **Form Validation** - Real-time client-side validation for all forms
- 🗄️ **Cloud Storage** - Store user data securely in Firebase Firestore
- 🎨 **Modern UI** - Clean and user-friendly interface with custom widgets
- 📱 **Responsive Design** - Works seamlessly on all device sizes
- 🔄 **Auto-fill** - Automatic email field population after signup
- ⚡ **Firebase Integration** - Real-time database and authentication

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter** >= 3.0.0 ([Download Flutter](https://flutter.dev/docs/get-started/install))
- **Dart** >= 2.17.0 (comes with Flutter)
- **Git** ([Download Git](https://git-scm.com/))
- **Android Studio** or **Xcode** (for emulator/device)
- **Firebase Account** ([Create Firebase Project](https://firebase.google.com/))

---

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Mrxforte/crm_pro.git
cd crm_pro
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or use existing one
3. Add Android app:
   - Package name: `com.example.crm_pro`
   - Download `google-services.json`
   - Place in `android/app/`
4. Enable Firestore Database
5. Set up Firestore Security Rules (see Configuration section)
6. Enable Email/Password Authentication in Firebase Console

### 4. Deploy Firestore Rules

```bash
firebase login
firebase deploy --only firestore:rules
```

### 5. Run the App

```bash
# For Android
flutter run

# For iOS
flutter run -d iphone

# For Web
flutter run -d chrome
```

---

## 📁 Project Structure

```
crm_pro/
├── android/                      # Android-specific files
│   └── app/
│       ├── google-services.json  # Firebase configuration
│       └── build.gradle.kts      # Android build settings
├── ios/                          # iOS-specific files
├── assets/                       # App resources
│   ├── fonts/                    # Custom fonts
│   ├── icons/                    # App icons
│   ├── images/                   # Images
│   └── logos/                    # Logo files
├── lib/                          # Main Dart source code
│   ├── main.dart                 # App entry point
│   ├── firebase_options.dart     # Firebase configuration
│   ├── common/                   # Shared resources
│   │   ├── app_colors.dart       # Color palette
│   │   ├── app_constants.dart    # App constants
│   │   ├── app_strings.dart      # Localized strings
│   │   ├── app_theme.dart        # Theme configuration
│   │   └── validators.dart       # Form validators
│   ├── controllers/              # Business logic
│   │   └── auth_controller.dart  # Authentication logic
│   ├── models/                   # Data models
│   ├── providers/                # State management
│   ├── views/                    # UI screens
│   │   ├── splash/               # Splash screen
│   │   ├── login/                # Login screen
│   │   ├── sign_up/              # Sign up screen
│   │   ├── welcome/              # Welcome screen
│   │   └── home/                 # Home screen
│   └── widgets/                  # Reusable widgets
│       ├── custom_text_field.dart
│       ├── heading_text.dart
│       ├── primary_button.dart
│       └── secondary_button.dart
├── test/                         # Test files
├── pubspec.yaml                  # Dependencies
├── pubspec.lock                  # Dependency lock file
├── analysis_options.yaml         # Dart analyzer options
├── firebase.json                 # Firebase CLI config
├── firestore.rules               # Firestore security rules
└── README.md                     # This file
```

---

## 🗂️ Folder Descriptions

### `lib/common/`
**Shared resources** used across the entire application:
- **app_colors.dart** - Centralized color definitions for consistent theming
- **app_constants.dart** - App-wide constants, dimensions, and padding values
- **app_strings.dart** - All UI text strings for easy localization
- **app_theme.dart** - Material Design theme configuration
- **validators.dart** - Reusable form validation functions

### `lib/controllers/`
**Business logic layer** that handles application operations:
- Firebase authentication workflows
- User registration and login logic
- Data validation before Firebase submission
- Error handling and user feedback

### `lib/views/`
**Screen/Page components** representing different UI states:
- **splash/** - Initial loading/splash screen
- **login/** - User login interface with validation
- **sign_up/** - User registration interface
- **welcome/** - Welcome/onboarding screen
- **home/** - Main application interface

### `lib/widgets/`
**Reusable UI components** for consistency:
- **custom_text_field.dart** - Enhanced text input with integrated validation
- **heading_text.dart** - Heading and typography components
- **primary_button.dart** - Main action buttons
- **secondary_button.dart** - Secondary action buttons

### `android/app/` & `ios/`
**Platform-specific code** for native features and configurations

### `assets/`
**Static resources** organized by type:
- Custom fonts for typography
- App icons and launcher images
- Images and graphics
- Logo files

---

## 🔐 Authentication Flow

### Sign Up Process
1. User enters email, full name, and password
2. Client-side validation checks:
   - Email format validity
   - Password minimum length (6 characters)
   - Full name minimum length (2 characters)
3. Form submission creates Firebase Auth user
4. User data is stored in Firestore collection
5. Auto-redirect to login screen with email pre-filled

### Login Process
1. User enters email and password
2. Credentials are verified with Firebase Auth
3. On success, user is redirected to home screen
4. Email field remains pre-filled for convenience

### Form Validation
- **Real-time validation** as user types
- **Error messages** displayed below fields
- **Submit button** disabled until all fields are valid
- **Centralized validators** for consistency

---

## ⚙️ Configuration Files

### `firebase.json`
Configures Firebase CLI deployment settings:
```json
{
  "firestore": {
    "rules": "firestore.rules"
  }
}
```

### `firestore.rules`
Security rules ensuring data protection:
```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Only authenticated users can access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // All other access denied by default
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### `pubspec.yaml`
Project dependencies and metadata:
- `firebase_auth` - User authentication
- `cloud_firestore` - Cloud database
- `firebase_core` - Firebase initialization
- `firebase_storage` - File storage
- `path_provider` - File system access

---

## 📱 Building for Production

### Android APK
```bash
flutter build apk --release
```

### iOS App
```bash
flutter build ios --release
```

### Web Application
```bash
flutter build web --release
```

---

## 🧪 Testing

Run all tests:
```bash
flutter test
```

Run specific test file:
```bash
flutter test test/widget_test.dart
```

---

## 🐛 Troubleshooting

### Firebase Connection Issues
- ✔️ Verify `google-services.json` is in `android/app/`
- ✔️ Check Firebase project ID matches in `firebase.json`
- ✔️ Ensure Firestore Database is enabled in Firebase Console
- ✔️ Verify Authentication is enabled in Firebase Console

### Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub upgrade

# Resolve Android issues
cd android && ./gradlew clean && cd ..
```

### Hot Reload Not Working
```bash
flutter run --no-hot
```

### Firestore Permission Denied Errors
- Verify security rules are deployed: `firebase deploy --only firestore:rules`
- Check Firestore rules syntax in `firestore.rules`
- Ensure user is authenticated before accessing data

---

## 🔄 Git Workflow

```bash
# Check current status
git status

# Stage all changes
git add .

# Commit with clear message
git commit -m "feat: Describe your changes"

# Push to remote repository
git push origin main

# Pull latest changes
git pull origin main
```

---

## 📊 Dependencies Overview

| Package | Version | Purpose |
|---------|---------|---------|
| `firebase_auth` | Latest | User authentication |
| `cloud_firestore` | Latest | Cloud database |
| `firebase_core` | Latest | Firebase initialization |
| `firebase_storage` | Latest | File storage |
| `path_provider` | Latest | File system access |
| `flutter` | >=3.0.0 | Flutter SDK |

---

## 🤝 Contributing

Contributions are welcome! Here's how:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/YourFeature`
3. **Commit** your changes: `git commit -m 'Add YourFeature'`
4. **Push** to the branch: `git push origin feature/YourFeature`
5. **Open** a Pull Request with clear description

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👨‍💻 Author

**Azamat** - CRM Pro Developer

---

## 📞 Support & Contact

For issues, questions, or suggestions:
- 📧 Email: support@crmpro.dev
- 🐛 Report bugs: [GitHub Issues](https://github.com/Mrxforte/crm_pro/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/Mrxforte/crm_pro/discussions)

---

## 🌟 Show Your Support

If this project helped you, please give it a ⭐️!

---

**Last Updated:** March 5, 2026  
**Version:** 1.0.0
