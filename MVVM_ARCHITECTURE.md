# MVVM Architecture Guide 📐

This document explains the MVVM (Model-View-ViewModel) architecture implemented in CRM Pro using Provider and GetIt.

---

## 🏗️ Architecture Overview

```
┌─────────────────┐
│    View (UI)    │  ← Flutter Widgets (Login, SignUp, etc.)
└────────┬────────┘
         │ uses
         ↓
┌─────────────────┐
│   ViewModel     │  ← State Management (AuthViewModel)
└────────┬────────┘
         │ uses
         ↓
┌─────────────────┐
│   Controller    │  ← Business Logic (AuthController)
└────────┬────────┘
         │ uses
         ↓
┌─────────────────┐
│   Firebase      │  ← External Services (Auth, Firestore)
└─────────────────┘
```

---

## 📁 Project Structure (MVVM)

```
lib/
├── core/
│   └── service_locator.dart      # GetIt dependency injection setup
├── controllers/
│   └── auth_controller.dart      # Business logic layer
├── viewmodels/
│   └── auth_viewmodel.dart       # State management with Provider
├── views/
│   ├── login/
│   │   └── login_screen.dart     # UI consuming ViewModel
│   └── sign_up/
│       └── sign_up_screen.dart   # UI consuming ViewModel
└── ...
```

---

## 🔑 Key Components

### 1. **Controller** (`lib/controllers/auth_controller.dart`)

**Purpose:** Business logic layer for Firebase operations

**Responsibilities:**
- Authenticate users with Firebase
- Register new users
- Handle errors from Firebase
- Return results to ViewModel

```dart
class AuthController {
  Future<String> registerNewUser(String email, String fullname, String password)
  Future<String> loginUser(String email, String password)
  Future<String> logout()
}
```

**Key Points:**
- Pure business logic (no UI dependencies)
- No direct access to BuildContext
- Returns plain String messages
- Handles all Firebase operations

### 2. **ViewModel** (`lib/viewmodels/auth_viewmodel.dart`)

**Purpose:** State management and UI coordination

**Responsibilities:**
- Manage loading state
- Handle authentication operations
- Manage error/success messages
- Notify UI of state changes
- Extend `ChangeNotifier` for Provider integration

```dart
class AuthViewModel extends ChangeNotifier {
  // State
  bool _isLoading = false;
  String _message = '';
  bool _isSuccess = false;
  
  // Methods
  Future<bool> registerNewUser(...)
  Future<bool> loginUser(...)
  Future<bool> logout()
  void clearMessage()
  void resetState()
}
```

**Key Points:**
- Extends `ChangeNotifier` for reactivity
- Calls controller methods
- Manages UI state (loading, messages, success)
- Returns success/failure boolean
- Notifies listeners of state changes

### 3. **View** (UI Screens)

**Purpose:** Display UI and respond to user interactions

**Responsibilities:**
- Display form fields
- Handle user input
- Display loading indicators
- Show error/success messages
- Navigate based on business logic results

```dart
class LoginScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthViewModel>();
    
    // Check loading state
    if (authViewModel.isLoading) {
      return LoadingDialog();
    }
    
    // Handle login
    await authViewModel.loginUser(
      email: emailController.text,
      password: passwordController.text,
    );
  }
}
```

**Key Points:**
- Uses `Provider` package for dependency injection
- Read ViewModel using `context.read<AuthViewModel>()`
- Watch state using `context.watch<AuthViewModel>()`
- No business logic in UI
- Pure presentation

### 4. **Service Locator** (`lib/core/service_locator.dart`)

**Purpose:** Dependency injection using GetIt

**Responsibilities:**
- Register all services and ViewModels
- Provide single-source-of-truth for instance creation
- Enable easy testing by swapping implementations

```dart
final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register Controller as Singleton
  getIt.registerSingleton<AuthController>(AuthController());
  
  // Register ViewModel with dependency
  getIt.registerSingleton<AuthViewModel>(
    AuthViewModel(getIt<AuthController>()),
  );
}
```

**Key Points:**
- Called in `main()` before `runApp()`
- Uses Singleton pattern for singletons
- Manages all dependency instantiation
- Easy to mock for testing

---

## 🔄 Data Flow Example: Login

### Step 1: User Interaction
```dart
// User taps login button
final authViewModel = context.read<AuthViewModel>();
await authViewModel.loginUser(
  email: emailController.text,
  password: passwordController.text,
);
```

### Step 2: ViewModel Processing
```dart
// AuthViewModel.loginUser()
_isLoading = true;
notifyListeners(); // Notify UI to show loading

final result = await _authController.loginUser(email, password);

_isSuccess = result == "User logged in successfully";
_message = result;
_isLoading = false;
notifyListeners(); // Notify UI of completion
```

### Step 3: Controller Execution
```dart
// AuthController.loginUser()
try {
  await auth.signInWithEmailAndPassword(email: email, password: password);
  return "User logged in successfully";
} catch (e) {
  // Handle error
  return "Login failed: ${e.message}";
}
```

### Step 4: UI Update
```dart
// UI rebuilds due to notifyListeners()
if (authViewModel.isSuccess) {
  // Navigate to home
} else {
  // Show error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(authViewModel.message))
  );
}
```

---

## 📦 Provider Integration

### Main MultiProvider Setup
```dart
// main.dart
void main() async {
  setupServiceLocator();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => getIt<AuthViewModel>(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
```

### Reading ViewModel in Widgets
```dart
// One-time read (for events)
final viewModel = context.read<AuthViewModel>();

// Watch for changes (rebuilds widget)
final viewModel = context.watch<AuthViewModel>();

// Check loading state
if (context.watch<AuthViewModel>().isLoading) {
  return LoadingIndicator();
}
```

---

## ✅ Benefits of MVVM

| Benefit | Description |
|---------|-------------|
| **Separation of Concerns** | Clear boundaries between layers |
| **Testability** | Easy to unit test each layer independently |
| **Reusability** | ViewModels can be used in multiple views |
| **Maintainability** | Easier to locate and fix bugs |
| **Scalability** | Easy to add new features without breaking existing |
| **State Management** | Centralized state management with Provider |
| **Dependency Injection** | Easy to mock dependencies with GetIt |

---

## 🧪 Testing Example

```dart
// Test ViewModel
void main() {
  group('AuthViewModel', () {
    late AuthViewModel viewModel;
    late MockAuthController mockController;
    
    setUp(() {
      mockController = MockAuthController();
      viewModel = AuthViewModel(mockController);
    });
    
    test('loginUser sets isLoading to true while loading', () {
      // Arrange
      when(mockController.loginUser(...))
          .thenAnswer((_) => Future.delayed(Duration(seconds: 1)));
      
      // Act
      viewModel.loginUser(email: 'test@test.com', password: '123456');
      
      // Assert
      expect(viewModel.isLoading, true);
    });
  });
}
```

---

## 🚀 Adding New Features

### Example: Add Forgot Password Feature

#### 1. Add to Controller
```dart
// auth_controller.dart
Future<String> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return "Password reset email sent";
  } catch (e) {
    return "Error: ${e.message}";
  }
}
```

#### 2. Add to ViewModel
```dart
// auth_viewmodel.dart
Future<bool> resetPassword({required String email}) async {
  _isLoading = true;
  notifyListeners();
  
  final result = await _authController.resetPassword(email);
  _isSuccess = result.contains("sent");
  _message = result;
  _isLoading = false;
  notifyListeners();
  
  return _isSuccess;
}
```

#### 3. Use in View
```dart
// forgot_password_screen.dart
PrimaryButton(
  onPressed: () async {
    final authViewModel = context.read<AuthViewModel>();
    await authViewModel.resetPassword(email: emailController.text);
    
    if (authViewModel.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authViewModel.message))
      );
    }
  },
)
```

---

## 🔗 Package References

- **Provider** - State management ([pub.dev](https://pub.dev/packages/provider))
- **GetIt** - Dependency injection ([pub.dev](https://pub.dev/packages/get_it))
- **Firebase Auth** - Authentication ([pub.dev](https://pub.dev/packages/firebase_auth))
- **Cloud Firestore** - Database ([pub.dev](https://pub.dev/packages/cloud_firestore))

---

## 📚 Best Practices

✅ **DO:**
- Keep Controllers focused on business logic only
- Use ViewModels for all state management
- Use GetIt for dependency injection
- Extend ChangeNotifier for reactive ViewModels
- Use context.read for one-time access
- Use context.watch for listening to changes

❌ **DON'T:**
- Put business logic in Views
- Call Firebase directly from Views
- Create new controller instances in Views
- Use global variables for state
- Mix concerns between layers

---

**Version:** 1.0.0  
**Last Updated:** March 5, 2026
