import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/base_screen.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/login/login_state.dart';
import 'package:lumina_medical_center/features/auth/presentation/widgets/login_form.dart';
import 'package:lumina_medical_center/injection_container.dart';

import '../../../../core/errors/failure_extension.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            final role = state.role.toUpperCase();

            if (role.contains('ADMIN')) {
              context.go('/admin-dashboard');
            } else if (role.contains('DOCTOR')) {
              context.go('/doctor-dashboard');
            } else {
              context.go('/home');
            }
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.toUserMessage(context)),
                backgroundColor: context.colors.error,
                behavior: SnackBarBehavior.floating,
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
                  height: context.height * 0.75,
                  padding: context.paddingAllL,
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(context.radius.xxl),
                    ),
                  ),
                  child: const SingleChildScrollView(child: LoginForm()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
