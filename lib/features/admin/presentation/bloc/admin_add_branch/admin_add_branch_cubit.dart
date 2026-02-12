import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/admin/domain/usecases/admin_add_branch_usecase.dart';
import 'admin_add_branch_state.dart';

class AdminAddBranchCubit extends Cubit<AdminAddBranchState> {
  final AdminAddBranchUseCase _addBranchUseCase;

  AdminAddBranchCubit({required AdminAddBranchUseCase addBranchUseCase})
    : _addBranchUseCase = addBranchUseCase,
      super(const AdminAddBranchState());

  Future<void> saveBranch({
    required String name,
    required String imageUrl,
  }) async {
    if (name.trim().isEmpty) {
      emit(
        state.copyWith(
          status: AdminAddBranchStatus.failure,

          errorMessage: "branchNameEmpty",
        ),
      );
      return;
    }

    emit(state.copyWith(status: AdminAddBranchStatus.loading));

    final result = await _addBranchUseCase(
      name: name.trim(),
      imageUrl: imageUrl.trim(),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminAddBranchStatus.failure,
          errorMessage: failure.errorMessage,
        ),
      ),
      (success) => emit(state.copyWith(status: AdminAddBranchStatus.success)),
    );
  }

  void reset() {
    emit(const AdminAddBranchState());
  }
}
