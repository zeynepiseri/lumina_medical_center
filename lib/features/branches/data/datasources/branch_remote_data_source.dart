import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import '../models/branch_model.dart';

abstract class BranchRemoteDataSource {
  Future<List<BranchModel>> getAllBranches();
  Future<BranchModel> createBranch(Map<String, dynamic> branchData);
}

class BranchRemoteDataSourceImpl implements BranchRemoteDataSource {
  final ApiClient _apiClient;

  BranchRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<BranchModel>> getAllBranches() async {
    try {
      final response = await _apiClient.get('/branches');

      if (response is List) {
        return response.map((json) => BranchModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw ServerException(message: "Failed to fetch branches: $e");
    }
  }

  @override
  Future<BranchModel> createBranch(Map<String, dynamic> branchData) async {
    try {
      final response = await _apiClient.post('/branches', branchData);
      return BranchModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: "Failed to create branch: $e");
    }
  }
}
