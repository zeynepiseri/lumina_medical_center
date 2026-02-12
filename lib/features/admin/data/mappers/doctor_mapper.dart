import 'package:lumina_medical_center/features/admin/domain/usecases/update_doctor_usecase.dart';

import '../../domain/usecases/add_doctor_usecase.dart';

extension AddDoctorParamsExtension on AddDoctorParams {
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
      "nationalId": nationalId,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "imageUrl": imageUrl,
      "branchId": branchId,
      "title": title,
      "specialty": specialty,
      "diplomaNo": diplomaNo,
      "biography": biography,
      "experience": experience,
      "acceptedInsurances": acceptedInsurances,
      "subSpecialties": subSpecialties,
      "professionalExperiences": professionalExperiences,
      "educations": educations,
      "schedules": schedules,
    };
  }
}

extension UpdateDoctorParamsExtension on UpdateDoctorParams {
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "nationalId": nationalId,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "imageUrl": imageUrl,
      "branchId": branchId,
      "title": title,
      "specialty": specialty,
      "diplomaNo": diplomaNo,
      "biography": biography,
      "experience": experience,
      "patientCount": int.tryParse(patients) ?? 0,
      "acceptedInsurances": acceptedInsurances,
      "subSpecialties": subSpecialties,
      "professionalExperiences": professionalExperiences,
      "educations": educations,
      "schedules": schedules,
    };
  }
}
