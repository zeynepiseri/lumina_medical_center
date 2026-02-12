import 'package:lumina_medical_center/core/constants/api_constants.dart';

enum AppIcons {
  home('icons/home.svg'),
  profile('icons/user.svg'),
  settings('icons/settings.svg'),
  notification('icons/bell.svg');

  final String path;
  const AppIcons(this.path);

  String get url => "${NetworkConstants.imageBaseUrl}/$path";

  String optimizedUrl({int width = 200}) {
    return "$url?tr=w-$width";
  }
}

class AppImages {
  AppImages._();
  static String get _base => NetworkConstants.imageBaseUrl;

  static String get loginHero => "$_base/images/login_hero.png";
  static String get emptyState => "$_base/images/no_data.png";
  static String get onboarding1 => "$_base/images/onboard_1.png";

  static String optimize(String url, {int width = 400}) {
    return "$url?tr=w-$width";
  }
}

class AppLocalAssets {
  AppLocalAssets._();
  static const String logo = 'assets/images/logo.png';
  static const String loadingCircles =
      'assets/animations/CirclesLoadingAnimation.json';
}

class MedicalIcons {
  MedicalIcons._();
  static const String _base = 'assets/icons/medical';

  static const String cardiology = '$_base/ic_cardiology.svg';
  static const String neurology = '$_base/ic_neurology.svg';
  static const String oncology = '$_base/ic_oncology.svg';
  static const String gastro = '$_base/ic_gastro.svg';
  static const String emergency = '$_base/ic_emergency.svg';
  static const String dermatology = '$_base/ic_dermatology.svg';
  static const String ophthalmology = '$_base/ic_eye.svg';
  static const String psychiatry = '$_base/ic_psychiatry.svg';
  static const String orthopedics = '$_base/ic_orthopedics.svg';
  static const String gynecology = '$_base/ic_gynecology.svg';
  static const String urology = '$_base/ic_urology.svg';
  static const String pediatrics = '$_base/ic_pediatrics.svg';
  static const String internal = '$_base/ic_internal.svg';
  static const String ent = '$_base/ic_ent.svg';
  static const String radiology = '$_base/ic_radiology.svg';
  static const String surgery = '$_base/ic_surgery.svg';
  static const String unknown = '$_base/ic_internal.svg';
}
