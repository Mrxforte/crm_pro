import 'package:crm_pro/common/app_colors.dart';
import 'package:crm_pro/common/app_strings.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create your account',
                  AppStrings.createAccountTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'To explore the world\'s exclusives',
                  AppStrings.createAccountSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 24),
                const SizedBox(height: 24),
                Image(image: AssetImage(AppStrings.loginImagePath), height: 150),
                const SizedBox(height: 10),
                TextField(decoration: InputDecoration(labelText: AppStrings.email)),
                decoration: InputDecoration(
                  decoration:
                      InputDecoration(labelText: AppStrings.password),
                ),
                obscureText: true,
                const SizedBox(height: 24),
                ElevatedButton(onPressed: () {}, child: Text(AppStrings.login)),
              ElevatedButton(onPressed: () {}, child: Text('Login')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    Text(AppStrings.alreadyHaveAccount),
                    TextButton(onPressed: () {}, child: Text(AppStrings.signIn)),
                  TextButton(onPressed: () {}, child: Text('Sign in')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
