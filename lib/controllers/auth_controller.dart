import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  Future<String> registerNewUser(
    String email,
    String fullname,
    String password,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      // Create user with email and password
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user details to Firestore
      try {
        await firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullname': fullname,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (firestoreError) {
        // If Firestore fails, delete the created auth user
        await userCredential.user!.delete();
        return "Failed to save user data: $firestoreError";
      }

      return "User registered successfully";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "The email address is already in use by another account.";
      } else if (e.code == 'invalid-email') {
        return "The email address is not valid.";
      } else if (e.code == 'operation-not-allowed') {
        return "Email/password accounts are not enabled.";
      } else if (e.code == 'weak-password') {
        return "The password is too weak.";
      } else {
        return "An unknown error occurred: ${e.message}";
      }
    } catch (e) {
      return "An error occurred: $e";
    }
  }

  // login
  Future<String> loginUser(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "User logged in successfully";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user.";
      } else {
        return "An unknown error occurred: ${e.message}";
      }
    } catch (e) {
      return "An error occurred: $e";
    }
  }

  // logout
  Future<String> logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signOut();
      return "User logged out successfully";
    } catch (e) {
      return "An error occurred while logging out: $e";
    }
  }
}
