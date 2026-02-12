import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/base_screen.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      topBarColor: context.colors.secondary,
      backgroundColor: context.colors.secondary,
      body: SafeArea(
        child: Padding(
          padding: context.paddingAllL,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              Text(
                context.loc.welcomeTitle,
                style: context.textTheme.displayLarge?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              context.vSpaceM,
              Text(
                context.loc.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(flex: 1),
              Icon(
                Icons.health_and_safety,
                size: 150,
                color: context.colors.surface,
              ),

              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                height: context.layout.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => context.push('/register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.radius.xxl),
                    ),
                  ),
                  child: Text(
                    context.loc.createAccount,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colors.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              context.vSpaceM,
              SizedBox(
                width: double.infinity,
                height: context.layout.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => context.push('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.radius.xxl),
                    ),
                  ),
                  child: Text(
                    context.loc.loginButton,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colors.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              context.vSpaceXXL,
            ],
          ),
        ),
      ),
    );
  }
}
