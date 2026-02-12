import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumina_medical_center/features/branches/domain/usecases/get_all_branches_usecase.dart';

import 'branch_event.dart';
import 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final GetAllBranchesUseCase _getAllBranchesUseCase;

  BranchBloc({required GetAllBranchesUseCase getAllBranchesUseCase})
    : _getAllBranchesUseCase = getAllBranchesUseCase,
      super(BranchInitial()) {
    on<LoadBranchesEvent>(_onLoadBranches);
  }

  Future<void> _onLoadBranches(
    LoadBranchesEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    final result = await _getAllBranchesUseCase();
    result.fold(
      (failure) => emit(BranchError(failure.errorMessage)),
      (branches) => emit(BranchLoaded(branches)),
    );
  }
}
