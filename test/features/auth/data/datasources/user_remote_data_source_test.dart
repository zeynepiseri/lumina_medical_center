import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/network/api_client.dart';
import 'package:lumina_medical_center/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:lumina_medical_center/features/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late UserRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = UserRemoteDataSourceImpl(mockApiClient);
  });

  group('UserRemoteDataSourceImpl Tests', () {
    group('getCurrentUser', () {
      final tUserJson = {
        "id": 1,
        "fullName": "Test User",
        "email": "test@test.com",
        "role": "patient",
        "nationalId": "123",
        "phoneNumber": "555",
        "gender": "Male",
        "birthDate": "1990-01-01",
        "imageUrl": "http://image.com/1.jpg",
      };

      test(
        'should return UserModel when GET /users/me is successful',
        () async {
          when(
            () => mockApiClient.get('/users/me'),
          ).thenAnswer((_) async => tUserJson);

          final result = await dataSource.getCurrentUser();

          verify(() => mockApiClient.get('/users/me')).called(1);
          expect(result, isA<UserModel>());
          expect(result.fullName, 'Test User');
        },
      );

      test('should throw Exception if API returns an error', () async {
        when(
          () => mockApiClient.get('/users/me'),
        ).thenThrow(Exception('API Error'));

        expect(() => dataSource.getCurrentUser(), throwsA(isA<Exception>()));
      });
    });

    group('updateProfilePhoto', () {
      const tImageUrl = 'http://new-image.com';

      test(
        'should return true when PATCH /users/photo is successful',
        () async {
          when(
            () => mockApiClient.patch('/users/photo', {"imageUrl": tImageUrl}),
          ).thenAnswer((_) async => {});

          final result = await dataSource.updateProfilePhoto(tImageUrl);

          verify(
            () => mockApiClient.patch('/users/photo', {"imageUrl": tImageUrl}),
          ).called(1);
          expect(result, true);
        },
      );

      test('should throw Exception if API returns an error', () async {
        when(
          () => mockApiClient.patch(any(), any()),
        ).thenThrow(Exception('Patch Error'));

        expect(
          () => dataSource.updateProfilePhoto(tImageUrl),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('changePassword', () {
      const tCurrent = 'old';
      const tNew = 'new';

      test(
        'should not throw error when POST /users/change-password is successful',
        () async {
          // Arrange
          when(
            () => mockApiClient.post('/users/change-password', {
              "currentPassword": tCurrent,
              "newPassword": tNew,
            }),
          ).thenAnswer((_) async => {});

          await dataSource.changePassword(tCurrent, tNew);

          verify(
            () => mockApiClient.post('/users/change-password', {
              "currentPassword": tCurrent,
              "newPassword": tNew,
            }),
          ).called(1);
        },
      );

      test('should throw Exception if API returns an error', () async {
        when(
          () => mockApiClient.post(any(), any()),
        ).thenThrow(Exception('Post Error'));

        expect(
          () => dataSource.changePassword(tCurrent, tNew),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
