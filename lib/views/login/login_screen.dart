import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            // create your account
            Text('Create your account'),
            // to explore the worlds exclusives
            Text('To explore the world\'s exclusives'),
            // image
            Image(image: AssetImage('assets/images/login_image.png')),
            // email input
            TextField(decoration: InputDecoration(labelText: 'Email')),
            // password input
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            // login button
            ElevatedButton(
              onPressed: () {
                // Handle login logic here
              },
              child: Text('Login'),
            ),
            // already have an account? sign in button
            TextButton(
              onPressed: () {
                // Handle sign in logic here
              },
              child: Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
