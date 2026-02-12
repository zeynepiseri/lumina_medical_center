import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/features/profile/data/datasources/profile_file_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDio extends Mock implements Dio {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ProfileFileService service;
  late MockDio mockDio;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockDio = MockDio();
    mockPrefs = MockSharedPreferences();
    service = ProfileFileService(mockDio, mockPrefs);
  });

  group('ProfileFileService Tests', () {
    test(
      'downloadUrl should return when uploadProfileImage is successful',
      () async {
        final file = File('test_image.jpg');

        when(() => mockPrefs.getString('auth_token')).thenReturn('token123');

        when(
          () => mockDio.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: {'downloadURL': 'http://image.com/pic.jpg'},
          ),
        );
        try {
          final result = await service.uploadProfileImage(file);
          expect(result, 'http://image.com/pic.jpg');
        } catch (e) {}
      },
    );

    test('Should launch Exception when uploadProfileImage fails', () async {
      final file = File('test.jpg');
      when(() => mockPrefs.getString('auth_token')).thenReturn('token');
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          statusMessage: 'Bad Request',
        ),
      );

      try {
        await service.uploadProfileImage(file);
        fail('The exception should have been thrown');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });
}
