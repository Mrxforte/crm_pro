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
<<<<<<< HEAD
            // create your account bigger text
            Text(
              'Create your account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // to explore the worlds exclusives more smaller text
            Text(
              'To explore the world\'s exclusives',
              style: TextStyle(fontSize: 16),
            ),
=======
            // create your account
            Text('Create your account'),
            // to explore the worlds exclusives
            Text('To explore the world\'s exclusives'),
>>>>>>> d87634df6103c7c7870fa232d10e508268670a7b
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
<<<<<<< HEAD
            Row(
              children: [
                // grey text already have an account? and sign in button styeled with primary color and text split into two lines sign in in button only
                Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    // Handle sign in logic here text split into two lines signi in in button only
                  },
                  child: Text('Sign in'),
                ),
              ],
=======
            TextButton(
              onPressed: () {
                // Handle sign in logic here
              },
              child: Text('Already have an account? Sign in'),
>>>>>>> d87634df6103c7c7870fa232d10e508268670a7b
            ),
          ],
        ),
      ),
    );
  }
}
