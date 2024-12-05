class PreRegistration {
  final int? id;
  final int? eventScheduleId;
  final int? userId;
  final String? qrCode;

  PreRegistration({
    this.id,
    this.eventScheduleId,
    this.userId,
    this.qrCode,
  });

  factory PreRegistration.fromJson(Map<String, dynamic> json) {
    return PreRegistration(
      id: json['id'],
      eventScheduleId: json['event_schedule_id'],
      userId: json['user_id'],
      qrCode: json['qr_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_schedule_id': eventScheduleId,
      'user_id': userId,
      'qr_code': qrCode,
    };
  }
}
