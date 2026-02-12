import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/auth/presentation/widgets/gender_date_selector.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:lumina_medical_center/core/utils/context_extensions.dart';
import 'package:lumina_medical_center/core/utils/validators.dart';
import 'package:lumina_medical_center/core/init/theme/app_colors.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/register/register_state.dart';
import 'package:lumina_medical_center/features/auth/presentation/widgets/custom_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nationalIdController;
  late final TextEditingController _phoneController;
  late final TextEditingController _chronicController;
  late final TextEditingController _allergiesController;
  late final TextEditingController _medicationsController;

  String? _gender = 'Male';
  DateTime? _birthDate;
  bool _isPasswordVisible = false;

  final maskFormatter = MaskTextInputFormatter(
    mask: '(###) ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nationalIdController = TextEditingController();
    _phoneController = TextEditingController();
    _chronicController = TextEditingController();
    _allergiesController = TextEditingController();
    _medicationsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    _chronicController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_birthDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.loc.selectBirthDateError),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      context.read<RegisterCubit>().register(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        rawPhoneNumber: _phoneController.text,
        gender: _gender!,
        birthDate: _birthDate!,
        chronicDiseasesText: _chronicController.text,
        allergiesText: _allergiesController.text,
        medicationsText: _medicationsController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          context.vSpaceS,
          Text(
            context.loc.createAccount,
            style: context.textTheme.headlineMedium?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          context.vSpaceL,

          CustomAuthTextField(
            label: context.loc.fullNameLabel,
            controller: _nameController,
            validator: (val) => Validators.validateRequired(val, context.loc),
          ),
          CustomAuthTextField(
            label: context.loc.email,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (val) => Validators.validateEmail(val, context.loc),
          ),
          CustomAuthTextField(
            label: context.loc.passwordLabel,
            controller: _passwordController,
            isPassword: !_isPasswordVisible,
            suffixIcon: _isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            onSuffixTap: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
            validator: (val) => Validators.validateRequired(val, context.loc),
          ),
          CustomAuthTextField(
            label: context.loc.nationalID,
            controller: _nationalIdController,
            keyboardType: TextInputType.number,
            maxLength: 11,
            validator: (val) => Validators.validateNationalId(val, context.loc),
          ),
          CustomAuthTextField(
            label: context.loc.phoneNumber,
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [maskFormatter],
            validator: (val) => Validators.validatePhone(val, context.loc),
          ),

          GenderDateSelector(
            gender: _gender,
            birthDate: _birthDate,
            onGenderChanged: (val) => setState(() => _gender = val),
            onDateChanged: (val) => setState(() => _birthDate = val),
          ),
          context.vSpaceM,

          CustomAuthTextField(
            label: context.loc.chronicDiseasesHint,
            controller: _chronicController,
          ),
          CustomAuthTextField(
            label: context.loc.allergiesHint,
            controller: _allergiesController,
          ),
          CustomAuthTextField(
            label: context.loc.medicationsHint,
            controller: _medicationsController,
          ),

          context.vSpaceL,

          BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                height: context.layout.buttonHeight,
                child: ElevatedButton(
                  onPressed: state is RegisterLoading ? null : _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.secondary,
                    foregroundColor: context.colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.radius.xxl),
                    ),
                  ),
                  child: state is RegisterLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: context.colors.surface,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          context.loc.createAccount,
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
