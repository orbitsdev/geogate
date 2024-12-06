import 'package:geogate/features/event/model/attendance.dart';
import 'package:geogate/features/preregistration/model/pre_registration.dart';


class EventSchedule {
  final int? id;
  final int? eventId;
  final String? eventName;
  final String? scheduleDate;
  final String? startTime;
  final String? endTime;
  final bool? isActive;
  final List<Attendance>? attendances;
  final List<PreRegistration>? preRegistrations;
  final PreRegistration? hasPreRegistration;
  final Attendance? hasAttendance;

  EventSchedule({
    this.id,
    this.eventId,
    this.eventName,
    this.scheduleDate,
    this.startTime,
    this.endTime,
    this.isActive,
    this.attendances,
    this.preRegistrations,
    this.hasPreRegistration,
    this.hasAttendance,
  });

  factory EventSchedule.fromJson(Map<String, dynamic> json) {
    return EventSchedule(
      id: json['id'],
      eventId: json['event_id'],
      eventName: json['event_name'],
      scheduleDate: json['schedule_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isActive: json['is_active'],
      attendances: json['attendances'] != null
          ? (json['attendances'] as List)
              .map((att) => Attendance.fromJson(att))
              .toList()
          : [],
      preRegistrations: json['pre_registrations'] != null
          ? (json['pre_registrations'] as List)
              .map((pr) => PreRegistration.fromJson(pr))
              .toList()
          : [],
      hasPreRegistration: json['has_pre_registration'] != null
          ? PreRegistration.fromJson(json['has_pre_registration'])
          : null,
      hasAttendance: json['has_attendance'] != null
          ? Attendance.fromJson(json['has_attendance'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'event_name': eventName,
      'schedule_date': scheduleDate,
      'start_time': startTime,
      'end_time': endTime,
      'is_active': isActive,
      'attendances': attendances?.map((e) => e.toJson()).toList(),
      'pre_registrations': preRegistrations?.map((e) => e.toJson()).toList(),
      'has_pre_registration': hasPreRegistration?.toJson(),
      'has_attendance': hasAttendance?.toJson(),
    };
  }
}
