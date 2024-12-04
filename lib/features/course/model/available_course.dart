
import 'package:geogate/features/auth/model/campus.dart';

class AvailableCourse {
  final int? id;
  final String? courseCode;
  final String? courseDescription;
  final Campus? campus;

  AvailableCourse({
    this.id,
    this.courseCode,
    this.courseDescription,
    this.campus,
  });

  // Factory method to create an instance from JSON
  factory AvailableCourse.fromJson(Map<String, dynamic> json) {
    return AvailableCourse(
      id: json['id'],
      courseCode: json['course_code'],
      courseDescription: json['course_description'],
      campus: json['campus'] != null ? Campus.fromJson(json['campus']) : null,
    );
  }

  // Factory method to create an instance from a Map
  factory AvailableCourse.fromMap(Map<String, dynamic> map) {
    return AvailableCourse(
      id: map['id'],
      courseCode: map['course_code'],
      courseDescription: map['course_description'],
      campus: map['campus'] != null ? Campus.fromMap(map['campus']) : null,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_code': courseCode,
      'course_description': courseDescription,
      'campus': campus?.toJson(),
    };
  }

  // Convert to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_code': courseCode,
      'course_description': courseDescription,
      'campus': campus?.toMap(),
    };
  }

  // CopyWith method to create a modified instance
  AvailableCourse copyWith({
    int? id,
    String? courseCode,
    String? courseDescription,
    Campus? campus,
  }) {
    return AvailableCourse(
      id: id ?? this.id,
      courseCode: courseCode ?? this.courseCode,
      courseDescription: courseDescription ?? this.courseDescription,
      campus: campus ?? this.campus,
    );
  }

  @override
  String toString() {
    return 'AvailableCourse(id: $id, courseCode: $courseCode, courseDescription: $courseDescription, campus: $campus)';
  }
}
