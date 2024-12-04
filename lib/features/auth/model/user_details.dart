import 'package:geogate/features/course/model/course.dart';

class UserDetails {
  final int? id;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? fullAddress;
  final String? fullName;
  final String? birthday;
  final Course? course;

  UserDetails({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.fullAddress,
    this.fullName,
    this.birthday,
    this.course,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullAddress: json['full_address'],
      fullName: json['fullname'],
      birthday: json['birthday'],
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
    );
  }

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      id: map['id'],
      userId: map['user_id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      fullAddress: map['full_address'],
      fullName: map['fullname'],
      birthday: map['birthday'],
      course: map['course'] != null ? Course.fromMap(map['course']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'full_address': fullAddress,
      'fullname': fullName,
      'birthday': birthday,
      'course': course?.toJson(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'full_address': fullAddress,
      'fullname': fullName,
      'birthday': birthday,
      'course': course?.toMap(),
    };
  }

  UserDetails copyWith({
    int? id,
    int? userId,
    String? firstName,
    String? lastName,
    String? fullAddress,
    String? fullName,
    String? birthday,
    Course? course,
  }) {
    return UserDetails(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullAddress: fullAddress ?? this.fullAddress,
      fullName: fullName ?? this.fullName,
      birthday: birthday ?? this.birthday,
      course: course ?? this.course,
    );
  }
}
