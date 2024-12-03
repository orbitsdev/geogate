import 'package:geogate/features/auth/model/course.dart';
import 'package:geogate/features/auth/model/user_details.dart';

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? email;
  final String? image;
  final UserDetails? userDetails;
  final Course? course;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
    this.image,
    this.userDetails,
    this.course,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['full_name'],
      email: json['email'],
      image: json['image'],
      userDetails: json['user_details'] != null
          ? UserDetails.fromJson(json['user_details'])
          : null,
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'image': image,
      'user_details': userDetails?.toJson(),
      'course': course?.toJson(),
    };
  }

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    String? image,
    UserDetails? userDetails,
    Course? course,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      image: image ?? this.image,
      userDetails: userDetails ?? this.userDetails,
      course: course ?? this.course,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, fullName: $fullName, email: $email, image: $image, userDetails: $userDetails, course: $course)';
  }
}
