import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/update_profile_photo_usecase.dart';
import 'package:lumina_medical_center/features/profile/data/datasources/profile_file_service.dart';
import 'package:lumina_medical_center/features/profile/presentation/bloc/upload_bloc/upload_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileFileService extends Mock implements ProfileFileService {}

class MockUpdateProfilePhotoUseCase extends Mock
    implements UpdateProfilePhotoUseCase {}

void main() {
  late UploadBloc uploadBloc;
  late MockProfileFileService mockFileService;
  late MockUpdateProfilePhotoUseCase mockUpdateProfilePhotoUseCase;

  setUp(() {
    mockFileService = MockProfileFileService();
    mockUpdateProfilePhotoUseCase = MockUpdateProfilePhotoUseCase();
    uploadBloc = UploadBloc(mockFileService, mockUpdateProfilePhotoUseCase);
  });

  tearDown(() {
    uploadBloc.close();
  });

  final tFile = File('image.jpg');
  const tUrl = 'http://image.com/pic.jpg';

  group('UploadBloc Tests', () {
    test('Initial state should be UploadInitial', () {
      expect(uploadBloc.state, isA<UploadInitial>());
    });

    blocTest<UploadBloc, UploadState>(
      'When the installation and update are successful, [UploadLoading, UploadSuccess] should be propagated',
      build: () {
        when(
          () => mockFileService.uploadProfileImage(tFile),
        ).thenAnswer((_) async => tUrl);
        when(
          () => mockUpdateProfilePhotoUseCase(tUrl),
        ).thenAnswer((_) async => const Right(true));
        return uploadBloc;
      },
      act: (bloc) => bloc.add(UploadProfileImageEvent(tFile)),
      expect: () => [
        isA<UploadLoading>(),
        isA<UploadSuccess>().having((s) => s.response, 'url', tUrl),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'If the file service returns null (error) [UploadLoading, UploadFailure] should propagate',
      build: () {
        when(
          () => mockFileService.uploadProfileImage(tFile),
        ).thenAnswer((_) async => null);
        return uploadBloc;
      },
      act: (bloc) => bloc.add(UploadProfileImageEvent(tFile)),
      expect: () => [
        isA<UploadLoading>(),
        isA<UploadFailure>().having(
          (s) => s.errorMessage,
          'msg',
          'imageUploadServiceError',
        ),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'If the profile update usecase fails, [UploadLoading, UploadFailure] should be propagated.',
      build: () {
        when(
          () => mockFileService.uploadProfileImage(tFile),
        ).thenAnswer((_) async => tUrl);
        when(() => mockUpdateProfilePhotoUseCase(tUrl)).thenAnswer(
          (_) async => const Left(ServerFailure(debugMessage: 'Update Failed')),
        );
        return uploadBloc;
      },
      act: (bloc) => bloc.add(UploadProfileImageEvent(tFile)),
      expect: () => [
        isA<UploadLoading>(),
        isA<UploadFailure>().having(
          (s) => s.errorMessage,
          'msg',
          'Update Failed',
        ),
      ],
    );
  });
}
