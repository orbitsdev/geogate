import 'package:geogate/features/auth/model/campus.dart';

class Course {
  final int? id;
  final String? courseCode;
  final String? courseDescription;
  final Campus? campus;

  Course({
    this.id,
    this.courseCode,
    this.courseDescription,
    this.campus,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      courseCode: json['course_code'],
      courseDescription: json['course_description'],
      campus: json['campus'] != null ? Campus.fromJson(json['campus']) : null,
    );
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      courseCode: map['course_code'],
      courseDescription: map['course_description'],
      campus: map['campus'] != null ? Campus.fromMap(map['campus']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_code': courseCode,
      'course_description': courseDescription,
      'campus': campus?.toJson(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_code': courseCode,
      'course_description': courseDescription,
      'campus': campus?.toMap(),
    };
  }

  Course copyWith({
    int? id,
    String? courseCode,
    String? courseDescription,
    Campus? campus,
  }) {
    return Course(
      id: id ?? this.id,
      courseCode: courseCode ?? this.courseCode,
      courseDescription: courseDescription ?? this.courseDescription,
      campus: campus ?? this.campus,
    );
  }
}
