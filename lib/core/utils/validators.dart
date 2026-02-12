import 'package:lumina_medical_center/l10n/app_localizations.dart';

class Validators {
  static String? validateNationalId(String? value, AppLocalizations loc) {
    if (value == null || value.isEmpty) {
      return loc.requiredField;
    }

    if (value.length < 6 || value.length > 20) {
      return loc.invalidId;
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return loc.invalidId;
    }

    return null;
  }

  static String? validatePhone(String? value, AppLocalizations loc) {
    if (value == null || value.isEmpty) {
      return loc.requiredField;
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

    if (!phoneRegex.hasMatch(value)) {
      return loc.invalidPhone;
    }
    return null;
  }

  static String? validateRequired(String? value, AppLocalizations loc) {
    if (value == null || value.isEmpty) {
      return loc.requiredField;
    }
    return null;
  }

  static String? validateEmail(String? value, AppLocalizations loc) {
    if (value == null || value.isEmpty) {
      return loc.requiredField;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return loc.error;
    }
    return null;
  }
}
