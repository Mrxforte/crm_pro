import 'package:crm_pro/common/app_colors.dart';
import 'package:crm_pro/common/app_constants.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? textColor;
  final double? fontSize;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? AppColors.buttonPrimary,
          fontSize: fontSize ?? AppTextSizes.bodyLarge,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
