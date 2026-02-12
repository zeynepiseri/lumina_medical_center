class ScheduleEntity {
  final int? id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  const ScheduleEntity({
    this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}
