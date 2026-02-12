import '../../../../core/network/api_client.dart';
import '../models/patient_model.dart';

abstract class PatientRemoteDataSource {
  Future<PatientModel> getCurrentPatient();

  Future<void> updateVitals(Map<String, dynamic> updates);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final ApiClient client;

  PatientRemoteDataSourceImpl(this.client);

  @override
  Future<PatientModel> getCurrentPatient() async {
    final response = await client.get('/patients/me');
    return PatientModel.fromJson(response);
  }

  @override
  Future<void> updateVitals(Map<String, dynamic> updates) async {
    await client.patch('/patients/me/vitals', updates);
  }
}
