import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? _user;
  User? _firebaseUser;
  bool _isLoading = false;

  AppUser? get user => _user;
  User? get firebaseUser => _firebaseUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      _firebaseUser = _auth.currentUser;
      if (_firebaseUser != null) {
        await _loadUserData(_firebaseUser!.uid);
      }
    }
    notifyListeners();
  }

  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _user = AppUser.fromFirestore(doc);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> _clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? assignedProjectId,
  }) async {
    try {
      setLoading(true);

      // Only admin can register new users
      if (_user?.isAdmin != true && _user != null) {
        return 'Only admin can register new users';
      }

      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final newUser = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
        role: role,
        assignedProjectId: assignedProjectId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toFirestore());

      // If current user is registering (self-registration), update local state
      if (_user == null) {
        _firebaseUser = userCredential.user;
        _user = newUser;
        await _saveLoginState();
      }

      setLoading(false);
      return null;
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return e.message;
    } catch (e) {
      setLoading(false);
      return 'Registration failed: $e';
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      setLoading(true);

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firebaseUser = userCredential.user;
      await _loadUserData(_firebaseUser!.uid);

      if (_user == null) {
        return 'User data not found';
      }

      await _saveLoginState();
      setLoading(false);
      return null;
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      return e.message;
    } catch (e) {
      setLoading(false);
      return 'Login failed: $e';
    }
  }

  Future<void> logout() async {
    try {
      setLoading(true);
      await _auth.signOut();
      _user = null;
      _firebaseUser = null;
      await _clearLoginState();
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print('Logout error: $e');
    }
  }

  Future<void> updateUserProfile({
    String? name,
    UserRole? role,
    String? assignedProjectId,
  }) async {
    try {
      if (_user == null) return;

      _user!.name = name ?? _user!.name;
      _user!.role = role ?? _user!.role;
      _user!.assignedProjectId = assignedProjectId ?? _user!.assignedProjectId;
      _user!.updatedAt = DateTime.now();

      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .update(_user!.toFirestore());

      notifyListeners();
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
