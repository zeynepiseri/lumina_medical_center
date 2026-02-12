import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/base_screen.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/register/register_state.dart';
import 'package:lumina_medical_center/features/auth/presentation/widgets/register_form.dart';
import 'package:lumina_medical_center/injection_container.dart';

import '../../../../core/errors/failure_extension.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RegisterCubit>(),
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.loc.registrationSuccess),
                backgroundColor: AppColors.success,
              ),
            );
            context.go('/home');
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.toUserMessage(context)),
                backgroundColor: context.colors.error,
              ),
            );
          }
        },
        child: BaseScreen(
          topBarColor: Colors.blueGrey.shade800,
          overrideStatusBarIconsLight: true,
          body: Stack(
            children: [
              Container(
                height: context.height * 0.4,
                width: double.infinity,
                color: Colors.blueGrey.shade800,
              ),

              Positioned(
                top: context.paddingAllL.top + context.spacing.m,
                left: context.spacing.m,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: context.colors.surface,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: context.height * 0.85,
                  padding: context.paddingAllL,
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(context.radius.xxl),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const RegisterForm(),
                        context.vSpaceL,
                        _buildLoginLink(context),
                        context.vSpaceL,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.loc.alreadyHaveAccount,
          style: context.textTheme.bodyMedium,
        ),
        GestureDetector(
          onTap: () => context.pushReplacement('/login'),
          child: Text(
            context.loc.loginLink,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
