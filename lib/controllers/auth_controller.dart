import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  Future<String> registerNewUser(
    String email,
    String fullname,
    String password,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
    return "User registered successfully";
  }
}
