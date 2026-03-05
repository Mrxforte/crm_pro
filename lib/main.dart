import 'package:crm_pro/common/app_strings.dart';
import 'package:crm_pro/common/app_theme.dart';
import 'package:crm_pro/core/service_locator.dart';
import 'package:crm_pro/util/routes.dart';
import 'package:crm_pro/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthViewModel>()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGeneratedRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
