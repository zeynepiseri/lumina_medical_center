part of 'booking_bloc.dart';

enum BookingStatus { initial, loading, loaded, submitting, success, failure }

class BookingState extends Equatable {
  final BookingStatus status;
  final List<DateTime> bookedSlots;
  final List<DateTime> next14Days;

  final int selectedDateIndex;
  final String? selectedTime;
  final int selectedTabIndex; // 0: In-Person, 1: Online
  final int selectedConsultationIndex;
  final String? errorMessage;

  const BookingState({
    this.status = BookingStatus.initial,
    this.bookedSlots = const [],
    this.next14Days = const [],
    this.selectedDateIndex = -1,
    this.selectedTime,
    this.selectedTabIndex = 0,
    this.selectedConsultationIndex = -1,
    this.errorMessage,
  });
  DateTime? get selectedDate =>
      selectedDateIndex != -1 && selectedDateIndex < next14Days.length
      ? next14Days[selectedDateIndex]
      : null;

  BookingState copyWith({
    BookingStatus? status,
    List<DateTime>? bookedSlots,
    List<DateTime>? next14Days,
    int? selectedDateIndex,
    String? selectedTime,
    int? selectedTabIndex,
    int? selectedConsultationIndex,
    String? errorMessage,
  }) {
    return BookingState(
      status: status ?? this.status,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      next14Days: next14Days ?? this.next14Days,
      selectedDateIndex: selectedDateIndex ?? this.selectedDateIndex,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedConsultationIndex:
          selectedConsultationIndex ?? this.selectedConsultationIndex,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    bookedSlots,
    next14Days,
    selectedDateIndex,
    selectedTime,
    selectedTabIndex,
    selectedConsultationIndex,
    errorMessage,
  ];
}
