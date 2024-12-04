class UserDetails {
  final int? id;
  final int? userId;
  final String? firstName;
  final String? lastName;
  final String? fullAddress;
  final String? fullName;
  final String? birthday;
  final int? courseId;

  UserDetails({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.fullAddress,
    this.fullName,
    this.birthday,
    this.courseId,
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
      courseId: json['course_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'full_address': fullAddress,
      'fullname': firstName,
      'birthday': birthday,
      'course_id': courseId,
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
    int? courseId,
  }) {
    return UserDetails(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullAddress: fullAddress ?? this.fullAddress,
      fullName: fullName ?? this.fullName,
      birthday: birthday ?? this.birthday,
      courseId: courseId ?? this.courseId,
    );
  }

  @override
  String toString() {
    return 'UserDetails(id: $id, userId: $userId, firstName: $firstName, lastName: $lastName, fullAddress: $fullAddress, fullName: $fullName, birthday: $birthday, courseId: $courseId)';
  }
}
