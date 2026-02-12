import 'package:flutter/material.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';

class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.paddingAllL,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.primary, const Color(0xFF4B7BE5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(context.radius.xl),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing.s + 2,
                    vertical: context.spacing.xs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.surface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(context.radius.medium),
                  ),
                  child: Text(
                    context.loc.earlyDetection,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colors.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                context.vSpaceM,
                Text(
                  context.loc.checkUpPackage,
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.colors.surface,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                context.vSpaceM,
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.secondary,
                    foregroundColor: context.colors.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.radius.medium,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.spacing.l,
                      vertical: context.spacing.s,
                    ),
                  ),
                  child: Text(
                    context.loc.appointmentNow,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            width: 80,
            decoration: BoxDecoration(
              color: context.colors.surface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.medical_services_outlined,
              color: context.colors.surface,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
