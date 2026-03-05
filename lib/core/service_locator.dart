import 'package:crm_pro/controllers/auth_controller.dart';
import 'package:crm_pro/viewmodels/auth_viewmodel.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register services
  getIt.registerSingleton<AuthController>(AuthController());

  // Register ViewModels
  getIt.registerSingleton<AuthViewModel>(
    AuthViewModel(getIt<AuthController>()),
  );
}
