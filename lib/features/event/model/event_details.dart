
import 'package:geogate/features/auth/model/campus.dart';

class EventDetails {
  final int? id;
  final String? eventDescription;
  final String? startDate;
  final String? endDate;
  final bool? isActive;
  final Campus? campus;

  EventDetails({
    this.id,
    this.eventDescription,
    this.startDate,
    this.endDate,
    this.isActive,
    this.campus,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      id: json['id'],
      eventDescription: json['event_description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      isActive: json['is_active'],
      campus: json['campus'] != null ? Campus.fromJson(json['campus']) : null,
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
    };
  }
}
