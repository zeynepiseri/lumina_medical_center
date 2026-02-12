import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/utils/validators.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/login/login_state.dart';
import 'package:lumina_medical_center/features/auth/presentation/widgets/custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    if (kDebugMode) {
      _emailController.text = "admin@lumina.com";
      _passwordController.text = "password123";
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final emailError = Validators.validateEmail(email, context.loc);
    final passError = Validators.validateRequired(password, context.loc);

    if (emailError != null || passError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.loc.pleaseFillAllFields),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    context.read<LoginCubit>().login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          context.vSpaceS,
          Text(
            context.loc.welcomeBackTitle,
            style: context.textTheme.headlineMedium?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          context.vSpaceXL,

          CustomAuthTextField(
            label: context.loc.enterEmail,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomAuthTextField(
            label: context.loc.enterPassword,
            controller: _passwordController,
            isPassword: !_isPasswordVisible,
            suffixIcon: _isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            onSuffixTap: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: context.colors.primary,
                    onChanged: (val) => setState(() => _rememberMe = val!),
                  ),
                  Text(
                    context.loc.rememberMe,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  context.loc.forgotPassword,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          context.vSpaceL,

          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                height: context.layout.buttonHeight,
                child: ElevatedButton(
                  onPressed: state is LoginLoading ? null : _onLoginPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.secondary,
                    foregroundColor: context.colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.radius.xxl),
                    ),
                  ),
                  child: state is LoginLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: context.colors.surface,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          context.loc.loginButton,
                          style: context.textTheme.titleLarge?.copyWith(
                            color: context.colors.surface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
