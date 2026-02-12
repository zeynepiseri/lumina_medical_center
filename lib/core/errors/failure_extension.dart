import 'package:flutter/widgets.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/l10n/app_localizations.dart';

extension FailureToMessage on Failure {
  String toUserMessage(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return switch (this) {
      NetworkFailure() => loc.anErrorHasOccurred,
      ServerFailure(errorCode: var code) => _mapServerCodeToMessage(code, loc),
      AuthFailure() => loc.operationFailed,
      _ => loc.unknown,
    };
  }

  String _mapServerCodeToMessage(String? code, AppLocalizations loc) {
    return switch (code) {
      'USER_NOT_FOUND' => loc.unknownPatient,
      'INVALID_CREDENTIALS' => loc.anErrorHasOccurred,
      _ => loc.anErrorHasOccurred,
    };
  }
}
