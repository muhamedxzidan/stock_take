import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final Key? fieldKey;
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool obscureText;
  final bool enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.fieldKey,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.obscureText = false,
    this.enabled = true,
    this.focusNode,
    this.textInputAction,
    this.autofillHints,
    this.onFieldSubmitted,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: AppSizes.h8),
        TextFormField(
          key: fieldKey,
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          maxLines: maxLines,
          obscureText: obscureText,
          enabled: enabled,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          inputFormatters: inputFormatters,
          autocorrect: !obscureText,
          enableSuggestions: !obscureText,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColors.primary,
                    size: AppSizes.iconMd,
                  )
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.r12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
