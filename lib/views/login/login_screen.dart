import 'package:crm_pro/common/app_colors.dart';
import 'package:crm_pro/common/app_constants.dart';
import 'package:crm_pro/common/app_strings.dart';
import 'package:crm_pro/views/sign_up/sign_up_screen.dart';
import 'package:crm_pro/widgets/custom_text_field.dart';
import 'package:crm_pro/widgets/heading_text.dart';
import 'package:crm_pro/widgets/primary_button.dart';
import 'package:crm_pro/widgets/secondary_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              CustomTextField(
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                label: AppStrings.passwordLabel,
                hint: AppStrings.passwordHint,
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              PrimaryButton(
                label: AppStrings.loginButton,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    debugPrint('Form is valid, proceed with login');
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
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
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
