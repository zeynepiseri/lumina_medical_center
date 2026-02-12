import 'package:flutter/material.dart';

class TimeSlotGenerator {
  static List<String> generate({
    required int startHour,
    required int endHour,
    int intervalMinutes = 30,
  }) {
    List<String> slots = [];

    DateTime currentTime = DateTime(2025, 1, 1, startHour, 0);
    DateTime endTime = DateTime(2025, 1, 1, endHour, 0);

    while (currentTime.isBefore(endTime)) {
      String formattedTime =
          "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}";
      slots.add(formattedTime);

      currentTime = currentTime.add(Duration(minutes: intervalMinutes));
    }

    return slots;
  }
}
