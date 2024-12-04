
class Attendance {
  final int? id;
  final int? eventScheduleId;
  final int? userId;
  final String? latitude;
  final String? longitude;
  final String? checkInTime;
  final String? checkOutTime;
  final String? geofenceOutTime;
  final bool? isPresent;

  Attendance({
    this.id,
    this.eventScheduleId,
    this.userId,
    this.latitude,
    this.longitude,
    this.checkInTime,
    this.checkOutTime,
    this.geofenceOutTime,
    this.isPresent,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      eventScheduleId: json['event_schedule_id'],
      userId: json['user_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      checkInTime: json['in'],
      checkOutTime: json['out'],
      geofenceOutTime: json['geofence_out'],
      isPresent: json['is_present'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_schedule_id': eventScheduleId,
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      'in': checkInTime,
      'out': checkOutTime,
      'geofence_out': geofenceOutTime,
      'is_present': isPresent,
    };
  }
}
