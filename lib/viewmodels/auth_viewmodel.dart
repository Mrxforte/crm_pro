import 'package:crm_pro/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthController _authController;

  AuthViewModel(this._authController);

  // State variables
  bool _isLoading = false;
  String _message = '';
  bool _isSuccess = false;

  // Getters
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get isSuccess => _isSuccess;

  // Register new user
  Future<bool> registerNewUser({
    required String email,
    required String fullname,
    required String password,
  }) async {
    _isLoading = true;
    _isSuccess = false;
    _message = '';
    notifyListeners();

    final result = await _authController.registerNewUser(
      email,
      fullname,
      password,
    );

    _isSuccess = result == "User registered successfully";
    _message = result;
    _isLoading = false;
    notifyListeners();

    return _isSuccess;
  }

  // Login user
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _isSuccess = false;
    _message = '';
    notifyListeners();

    final result = await _authController.loginUser(email, password);

    _isSuccess = result == "User logged in successfully";
    _message = result;
    _isLoading = false;
    notifyListeners();

    return _isSuccess;
  }

  // Logout user
  Future<bool> logout() async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    final result = await _authController.logout();

    _isSuccess = result == "User logged out successfully";
    _message = result;
    _isLoading = false;
    notifyListeners();

    return _isSuccess;
  }

  // Clear messages
  void clearMessage() {
    _message = '';
    notifyListeners();
  }

  // Reset state
  void resetState() {
    _isLoading = false;
    _message = '';
    _isSuccess = false;
    notifyListeners();
  }
}
