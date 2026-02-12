import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../injection_container.dart' as di;

final class AppInitializer {
  AppInitializer._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      debugPrint(details.exceptionAsString());
    };

    await _setupSystemUI();
    await di.init();
  }

  static Future<void> _setupSystemUI() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
}
