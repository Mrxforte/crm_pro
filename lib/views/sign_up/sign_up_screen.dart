import 'package:crm_pro/common/app_colors.dart';
import 'package:crm_pro/common/app_constants.dart';
import 'package:crm_pro/common/app_strings.dart';
import 'package:crm_pro/controllers/auth_controller.dart';
import 'package:crm_pro/views/login/login_screen.dart';
import 'package:crm_pro/widgets/custom_text_field.dart';
import 'package:crm_pro/widgets/heading_text.dart';
import 'package:crm_pro/widgets/primary_button.dart';
import 'package:crm_pro/widgets/secondary_button.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        key: formKey,
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
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              CustomTextField(
                // full name
                controller: fullNameController,
                label: AppStrings.fullNameLabel,
                hint: AppStrings.fullNameHint,
                icon: Icons.person,
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              CustomTextField(
                controller: passwordController,
                label: AppStrings.passwordLabel,
                hint: AppStrings.passwordHint,
                icon: Icons.lock,
                isPassword: true,
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              PrimaryButton(
                label: AppStrings.signUpButton,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    String result = await authController.registerNewUser(
                      emailController.text,
                      fullNameController.text,
                      passwordController.text,
                    );
                    debugPrint(result);
                  } else {
                    debugPrint('Form is invalid, show errors');
                  }
                },
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubtitleText(AppStrings.alreadyHaveAccount),
                  SecondaryButton(
                    label: AppStrings.signIn,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
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
