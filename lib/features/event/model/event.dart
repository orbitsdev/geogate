import 'package:geogate/features/auth/model/campus.dart';
import 'package:geogate/features/event/model/event_schedule.dart';


class Event {
  final int? id;
  final String? eventDescription;
  final String? startDate;
  final String? endDate;
  final bool? isActive;
  final Campus? campus;
  final List<EventSchedule>? eventSchedules;
  final EventSchedule? activeSchedule;

  Event({
    this.id,
    this.eventDescription,
    this.startDate,
    this.endDate,
    this.isActive,
    this.campus,
    this.eventSchedules,
    this.activeSchedule,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      eventDescription: json['event_description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      isActive: json['is_active'],
      campus: json['campus'] != null ? Campus.fromJson(json['campus']) : null,
      eventSchedules: json['event_schedules'] != null
          ? (json['event_schedules'] as List)
              .map((schedule) => EventSchedule.fromJson(schedule))
              .toList()
          : [],
      activeSchedule: json['active_schedule'] != null
          ? EventSchedule.fromJson(json['active_schedule'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_description': eventDescription,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': isActive,
      'campus': campus?.toJson(),
      'event_schedules': eventSchedules?.map((e) => e.toJson()).toList(),
      'active_schedule': activeSchedule?.toJson(),
    };
  }

  Event copyWith({
    int? id,
    String? eventDescription,
    String? startDate,
    String? endDate,
    bool? isActive,
    Campus? campus,
    List<EventSchedule>? eventSchedules,
    EventSchedule? activeSchedule,
  }) {
    return Event(
      id: id ?? this.id,
      eventDescription: eventDescription ?? this.eventDescription,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      campus: campus ?? this.campus,
      eventSchedules: eventSchedules ?? this.eventSchedules,
      activeSchedule: activeSchedule ?? this.activeSchedule,
    );
  }
}
