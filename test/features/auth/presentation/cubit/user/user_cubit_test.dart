import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina_medical_center/core/errors/failures.dart';
import 'package:lumina_medical_center/features/auth/domain/entities/user_entity.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/get_user_usecase.dart';
import 'package:lumina_medical_center/features/auth/domain/usecases/update_profile_photo_usecase.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/user/user_cubit.dart';
import 'package:lumina_medical_center/features/auth/presentation/cubit/user/user_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

class MockUpdateProfilePhotoUseCase extends Mock
    implements UpdateProfilePhotoUseCase {}

class MockUserEntity extends Mock implements UserEntity {}

void main() {
  late UserCubit userCubit;
  late MockGetUserUseCase mockGetUserUseCase;
  late MockUpdateProfilePhotoUseCase mockUpdateProfilePhotoUseCase;
  late MockUserEntity mockUser;

  setUp(() {
    mockGetUserUseCase = MockGetUserUseCase();
    mockUpdateProfilePhotoUseCase = MockUpdateProfilePhotoUseCase();
    mockUser = MockUserEntity();

    userCubit = UserCubit(
      getUserUseCase: mockGetUserUseCase,
      updateProfilePhotoUseCase: mockUpdateProfilePhotoUseCase,
    );
  });

  tearDown(() {
    userCubit.close();
  });

  group('UserCubit Tests', () {
    test('Initial state should be UserInitial', () {
      expect(userCubit.state, equals(UserInitial()));
    });

    group('loadUser', () {
      blocTest<UserCubit, UserState>(
        'should emit [UserLoading, UserLoaded] when user is loaded successfully',
        build: () {
          when(
            () => mockGetUserUseCase(),
          ).thenAnswer((_) async => Right(mockUser));
          return userCubit;
        },
        act: (cubit) => cubit.loadUser(),
        expect: () => [UserLoading(), UserLoaded(mockUser)],
        verify: (_) {
          verify(() => mockGetUserUseCase()).called(1);
        },
      );

      blocTest<UserCubit, UserState>(
        'should emit [UserLoading, UserError] if user cannot be loaded',
        build: () {
          when(() => mockGetUserUseCase()).thenAnswer(
            (_) async =>
                const Left(ServerFailure(debugMessage: 'User fetch failed')),
          );
          return userCubit;
        },
        act: (cubit) => cubit.loadUser(),
        expect: () => [UserLoading(), isA<UserError>()],
      );
    });

    group('updateProfilePhoto', () {
      const tImageUrl = 'path/to/image.jpg';

      blocTest<UserCubit, UserState>(
        'If photo update is successful, should emit uploading=true first, then reload flow',
        build: () {
          when(
            () => mockUpdateProfilePhotoUseCase(tImageUrl),
          ).thenAnswer((_) async => const Right(true));

          when(
            () => mockGetUserUseCase(),
          ).thenAnswer((_) async => Right(mockUser));

          return userCubit;
        },

        seed: () => UserLoaded(mockUser),
        act: (cubit) => cubit.updateProfilePhoto(tImageUrl),
        expect: () => [
          UserLoaded(mockUser, isPhotoUploading: true),

          UserLoading(),

          UserLoaded(mockUser),
        ],
        verify: (_) {
          verify(() => mockUpdateProfilePhotoUseCase(tImageUrl)).called(1);
          verify(() => mockGetUserUseCase()).called(1);
        },
      );

      blocTest<UserCubit, UserState>(
        'If photo update fails, should revert to uploading=false',
        build: () {
          when(() => mockUpdateProfilePhotoUseCase(tImageUrl)).thenAnswer(
            (_) async =>
                const Left(ServerFailure(debugMessage: 'Upload failed')),
          );
          return userCubit;
        },
        seed: () => UserLoaded(mockUser),
        act: (cubit) => cubit.updateProfilePhoto(tImageUrl),
        expect: () => [
          UserLoaded(mockUser, isPhotoUploading: true),

          UserLoaded(mockUser, isPhotoUploading: false),
        ],
      );
    });
  });
}
