import 'package:crm_pro/common/app_colors.dart';
import 'package:crm_pro/common/app_constants.dart';
import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color? color;
  final FontWeight fontWeight;

  const HeadingText(
    this.text, {
    super.key,
    this.textAlign = TextAlign.left,
    this.color,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: AppTextSizes.headlineSmall,
        fontWeight: fontWeight,
        color: color ?? AppColors.textPrimary,
      ),
    );
  }
}

class SubtitleText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color? color;
  final FontWeight fontWeight;

  const SubtitleText(
    this.text, {
    super.key,
    this.textAlign = TextAlign.left,
    this.color,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: AppTextSizes.bodyLarge,
        fontWeight: fontWeight,
        color: color ?? AppColors.textSecondary,
      ),
    );
  }
}
