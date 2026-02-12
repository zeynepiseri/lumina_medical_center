import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class CustomAuthTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomAuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: context.textTheme.bodyLarge?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: context.textTheme.bodyLarge?.copyWith(
              color: context.colors.primary.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: context.colors.surface,
            counterText: "",

            contentPadding: EdgeInsets.symmetric(
              horizontal: context.spacing.l,
              vertical: context.spacing.m,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.radius.xxl),
              borderSide: BorderSide(color: context.colors.primary, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.radius.xxl),
              borderSide: BorderSide(color: context.colors.primary, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.radius.xxl),
              borderSide: BorderSide(color: context.colors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.radius.xxl),
              borderSide: BorderSide(color: context.colors.error, width: 2.0),
            ),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon, color: context.colors.primary),
                  )
                : null,
          ),
        ),

        context.vSpaceM,
      ],
    );
  }
}
