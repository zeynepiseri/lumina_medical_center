import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/widgets/base_screen.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_add_branch/admin_add_branch_cubit.dart';
import 'package:lumina_medical_center/features/admin/presentation/bloc/admin_add_branch/admin_add_branch_state.dart';
import 'package:toastification/toastification.dart';
import '../../../../injection_container.dart';

class AddBranchPage extends StatelessWidget {
  const AddBranchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminAddBranchCubit>(),
      child: const _AddBranchView(),
    );
  }
}

class _AddBranchView extends StatefulWidget {
  const _AddBranchView();

  @override
  State<_AddBranchView> createState() => _AddBranchViewState();
}

class _AddBranchViewState extends State<_AddBranchView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminAddBranchCubit>();

    return BaseScreen(
      backgroundColor: AppColors.background,
      topBarColor: AppColors.background,
      body: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            context.loc.addBranchTitle,
            style: context.textTheme.titleMedium?.copyWith(
              color: AppColors.midnightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: AppColors.midnightBlue,
            size: context.layout.iconMedium,
          ),
        ),
        body: BlocConsumer<AdminAddBranchCubit, AdminAddBranchState>(
          listener: (context, state) {
            if (state.status == AdminAddBranchStatus.success) {
              toastification.show(
                context: context,
                type: ToastificationType.success,
                title: Text(context.loc.confirmed),
                description: Text(context.loc.saveSuccess),
                autoCloseDuration: 3.sec,
              );
              context.pop();
            } else if (state.status == AdminAddBranchStatus.failure) {
              toastification.show(
                context: context,
                type: ToastificationType.error,
                title: Text(context.loc.error),
                description: Text(
                  state.errorMessage ?? context.loc.anErrorHasOccurred,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.status == AdminAddBranchStatus.loading;

            return Center(
              child: SingleChildScrollView(
                padding: context.pagePadding,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: 500.w),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: context.paddingAllL,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: context.radius.large.radius,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withValues(
                              alpha: context.opacity.faint,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildModernTextField(
                            context,
                            context.loc.branchNameLabel,
                            context.loc.branchNameHint,
                            _nameController,
                          ),
                          context.vSpaceM,

                          _buildModernTextField(
                            context,
                            context.loc.imageUrlOptional,
                            context.loc.imageUrlHint,
                            _imageUrlController,
                            isRequired: false,
                          ),

                          context.vSpaceXL,

                          SizedBox(
                            width: double.infinity,
                            height: context.layout.buttonHeight.h,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        cubit.saveBranch(
                                          name: _nameController.text.trim(),
                                          imageUrl: _imageUrlController.text
                                              .trim(),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.oldGold,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: context.radius.medium.radius,
                                ),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      height: 24.h,
                                      width: 24.w,
                                      child: const CircularProgressIndicator(
                                        color: AppColors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      context.loc.saveBranchButton,
                                      style: context.textTheme.labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildModernTextField(
    BuildContext context,
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: AppColors.slateGray,
            fontWeight: FontWeight.w600,
          ),
        ),
        context.vSpaceS,
        TextFormField(
          controller: controller,
          style: context.textTheme.bodyMedium,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.slateGray.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: context.radius.medium.radius,
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.spacing.m.w,
              vertical: context.spacing.s.h,
            ),
          ),
          validator: (val) {
            if (!isRequired) return null;
            return (val == null || val.isEmpty)
                ? context.loc.requiredField
                : null;
          },
        ),
      ],
    );
  }
}
