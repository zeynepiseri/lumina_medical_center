import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';
import 'package:lumina_medical_center/features/branches/presentation/extensions/branch_ui_extension.dart';

class SpecialtyList extends StatefulWidget {
  final List<BranchEntity> specialties;

  const SpecialtyList({super.key, required this.specialties});

  @override
  State<SpecialtyList> createState() => _SpecialtyListState();
}

class _SpecialtyListState extends State<SpecialtyList> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.specialties.length,
        padding: context.paddingHorizontalM.copyWith(top: 5, bottom: 5),
        separatorBuilder: (context, index) => context.hSpaceL,
        itemBuilder: (context, index) {
          final branch = widget.specialties[index];
          final isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);

              context.pushNamed(
                'doctors_by_branch',
                pathParameters: {'branchId': branch.id},
                extra: branch.name,
              );
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  height: 72,
                  width: 72,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(context.radius.xl),
                    boxShadow: [
                      if (!isSelected)
                        BoxShadow(
                          color: context.colors.primary.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    branch.iconPath,
                    colorFilter: ColorFilter.mode(
                      isSelected
                          ? context.colors.secondary
                          : context.colors.primary,
                      BlendMode.srcIn,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                context.vSpaceS,
                Text(
                  branch.name,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
