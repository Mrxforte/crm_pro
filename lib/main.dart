import 'package:crm_pro/common/app_strings.dart';
import 'package:crm_pro/common/app_theme.dart';
import 'package:crm_pro/views/login/login_screen.dart';
import 'package:crm_pro/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {'/login': (context) => const LoginScreen()},
      debugShowCheckedModeBanner: false,
    );
  }
}
