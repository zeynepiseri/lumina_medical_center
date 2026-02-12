import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) print('🟢 BLOC OLUŞTU: ${bloc.runtimeType}');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) print('🔴 BLOC KAPANDI: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) print('🟡 EVENT GELDİ: ${bloc.runtimeType} -> $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      print(
        '🔵 STATE DEĞİŞTİ: ${bloc.runtimeType}\n'
        '   Eski: ${change.currentState.runtimeType}\n'
        '   Yeni: ${change.nextState.runtimeType}',
      );
    }
  }
}
