import 'package:geogate/features/auth/model/user.dart';

class PreRegistration {
  final int? id;
  final String? qrCode;
  final User? user; // Add the User model here

  PreRegistration({
    this.id,
    this.qrCode,
    this.user,
  });

  factory PreRegistration.fromJson(Map<String, dynamic> json) {
    return PreRegistration(
      id: json['id'],
      qrCode: json['qr_code'],
      user: json['user'] != null ? User.fromMap(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qr_code': qrCode,
      'user': user?.toJson(),
    };
  }
}
