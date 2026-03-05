// ignore_for_file: use_build_context_synchronously

import 'package:crm_pro/common/app_colors.dart';
import 'package:crm_pro/common/app_constants.dart';
import 'package:crm_pro/common/app_strings.dart';
import 'package:crm_pro/common/validators.dart';
import 'package:crm_pro/util/routes.dart';
import 'package:crm_pro/viewmodels/auth_viewmodel.dart';
import 'package:crm_pro/views/sign_up/sign_up_screen.dart';
import 'package:crm_pro/widgets/custom_text_field.dart';
import 'package:crm_pro/widgets/heading_text.dart';
import 'package:crm_pro/widgets/primary_button.dart';
import 'package:crm_pro/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final String? initialEmail;

  const LoginScreen({super.key, this.initialEmail});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController(text: widget.initialEmail ?? '');
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXLarge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeadingText(
                AppStrings.createAccountTitle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.paddingMedium),
              SubtitleText(
                AppStrings.createAccountSubtitle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              Image(
                image: const AssetImage(AppStrings.loginImagePath),
                height: AppDimensions.imageHeightLogin,
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              CustomTextField(
                controller: emailController,
                label: AppStrings.emailLabel,
                hint: AppStrings.emailHint,
                icon: Icons.email,
                validator: Validators.validateEmail,
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              CustomTextField(
                controller: passwordController,
                validator: Validators.validatePassword,
                label: AppStrings.passwordLabel,
                hint: AppStrings.passwordHint,
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              PrimaryButton(
                label: AppStrings.loginButton,
                isLoading: authViewModel.isLoading,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final success = await authViewModel.loginUser(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    if (success) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(authViewModel.message),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.home);
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(authViewModel.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } else {
                    debugPrint('Form is invalid, show errors');
                  }
                },
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubtitleText(AppStrings.dontYouHaveNotAccount),
                  SecondaryButton(
                    label: AppStrings.signUpButton,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
