import 'package:equatable/equatable.dart';

enum AdminAddBranchStatus { initial, loading, success, failure }

class AdminAddBranchState extends Equatable {
  final AdminAddBranchStatus status;
  final String? errorMessage;

  const AdminAddBranchState({
    this.status = AdminAddBranchStatus.initial,
    this.errorMessage,
  });

  AdminAddBranchState copyWith({
    AdminAddBranchStatus? status,
    String? errorMessage,
  }) {
    return AdminAddBranchState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
