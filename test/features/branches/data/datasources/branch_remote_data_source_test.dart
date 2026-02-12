import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/branches/data/datasources/branch_remote_data_source.dart';
import 'package:lumina_medical_center/features/branches/data/models/branch_model.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late BranchRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = BranchRemoteDataSourceImpl(mockApiClient);
  });

  group('BranchRemoteDataSourceImpl Tests', () {
    group('getAllBranches', () {
      final tBranchListJson = [
        {
          "id": "1",
          "name": "Cardiology",
          "shortName": "Cardio",
          "imageUrl": "url1",
        },
        {
          "id": "2",
          "name": "Neurology",
          "shortName": "Neuro",
          "imageUrl": "url2",
        },
      ];

      test(
        'should return List<BranchModel> when GET /branches is successful',
        () async {
          when(
            () => mockApiClient.get('/branches'),
          ).thenAnswer((_) async => tBranchListJson);

          final result = await dataSource.getAllBranches();

          verify(() => mockApiClient.get('/branches')).called(1);
          expect(result, isA<List<BranchModel>>());
          expect(result.length, 2);
          expect(result.first.name, 'Cardiology');
        },
      );

      test(
        'should return an empty list if API returns non-list data (Code implementation check)',
        () async {
          when(
            () => mockApiClient.get('/branches'),
          ).thenAnswer((_) async => {"error": "not a list"});

          final result = await dataSource.getAllBranches();

          expect(result, isEmpty);
        },
      );

      test('should throw ServerException if API returns an error', () async {
        when(
          () => mockApiClient.get('/branches'),
        ).thenThrow(Exception('Network Error'));

        expect(
          () => dataSource.getAllBranches(),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('createBranch', () {
      final tBranchData = {"name": "New Branch", "imageUrl": "img"};
      final tResponseJson = {
        "id": "3",
        "name": "New Branch",
        "shortName": "New",
        "imageUrl": "img",
      };

      test(
        'should return the created BranchModel when POST /branches is successful',
        () async {
          when(
            () => mockApiClient.post('/branches', tBranchData),
          ).thenAnswer((_) async => tResponseJson);

          final result = await dataSource.createBranch(tBranchData);

          verify(() => mockApiClient.post('/branches', tBranchData)).called(1);
          expect(result, isA<BranchModel>());
          expect(result.id, '3');
        },
      );

      test('should throw ServerException if API returns an error', () async {
        when(
          () => mockApiClient.post(any(), any()),
        ).thenThrow(Exception('Create Error'));

        expect(
          () => dataSource.createBranch(tBranchData),
          throwsA(isA<ServerException>()),
        );
      });
    });
  });
}
