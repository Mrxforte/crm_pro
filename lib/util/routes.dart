import 'package:crm_pro/views/cart/cart_screen.dart';
import 'package:crm_pro/views/favorite/favorite_screen.dart';
import 'package:crm_pro/views/login/login_screen.dart';
import 'package:crm_pro/views/main/main_screen.dart';
import 'package:crm_pro/views/profile/profile_screen.dart';
import 'package:crm_pro/views/sign_up/sign_up_screen.dart';
import 'package:crm_pro/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String main = '/main';
  static const String favorites = '/favorites';
  static const String cart = '/cart';
  static const String profile = '/profile';

  static Route<dynamic> onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case home:
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoriteScreen());
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
