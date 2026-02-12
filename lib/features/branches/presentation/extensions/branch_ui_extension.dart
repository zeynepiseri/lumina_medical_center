import 'package:lumina_medical_center/core/constants/app_assets.dart';
import 'package:lumina_medical_center/features/branches/domain/entities/branch_entity.dart';

extension BranchUIExtension on BranchEntity {
  String get iconPath {
    final normalized = (name ?? '').trim().toLowerCase();

    if (normalized.contains('cardiology')) return MedicalIcons.cardiology;
    if (normalized.contains('neurology')) return MedicalIcons.neurology;
    if (normalized.contains('oncology')) return MedicalIcons.oncology;
    if (normalized.contains('gastro')) return MedicalIcons.gastro;
    if (normalized.contains('emergency')) return MedicalIcons.emergency;
    if (normalized.contains('derm')) return MedicalIcons.dermatology;
    if (normalized.contains('ophthalmology')) return MedicalIcons.ophthalmology;
    if (normalized.contains('psych')) return MedicalIcons.psychiatry;
    if (normalized.contains('ortho')) return MedicalIcons.orthopedics;

    if (normalized.contains('gynecology') ||
        normalized.contains('obstetrics')) {
      return MedicalIcons.gynecology;
    }

    if (normalized.contains('urology')) return MedicalIcons.urology;
    if (normalized.contains('pedia')) return MedicalIcons.pediatrics;
    if (normalized.contains('internal')) return MedicalIcons.internal;

    if (normalized.contains('ear') || normalized.contains('ent')) {
      return MedicalIcons.ent;
    }

    if (normalized.contains('radio')) return MedicalIcons.radiology;
    if (normalized.contains('surgery')) return MedicalIcons.surgery;

    if (normalized.contains('therapy') || normalized.contains('physio')) {
      return MedicalIcons.orthopedics;
    }

    return MedicalIcons.unknown;
  }
}
