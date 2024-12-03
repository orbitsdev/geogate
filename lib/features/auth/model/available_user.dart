// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AvailableUser {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? image;
  final String? email;

  AvailableUser({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.image,
    this.email,
  });

  AvailableUser copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? fullName,
    String? image,
    String? email,
  }) {
    return AvailableUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      image: image ?? this.image,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'fullName': fullName,
      'image': image,
      'email': email,
    };
  }

  factory AvailableUser.fromMap(Map<String, dynamic> map) {
    return AvailableUser(
      id: map['id'] != null ? map['id'] as int : null,
      firstName: map['first_name'] != null ? map['first_name'] as String : null,
      lastName: map['last_name'] != null ? map['last_name'] as String : null,
      fullName: map['full_name'] != null ? map['full_name'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvailableUser.fromJson(String source) =>
      AvailableUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AvailableUser(id: $id, firstName: $firstName, lastName: $lastName, fullName: $fullName, image: $image, email: $email)';
  }

  @override
  bool operator ==(covariant AvailableUser other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.fullName == fullName &&
        other.image == image &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        fullName.hashCode ^
        image.hashCode ^
        email.hashCode;
  }
}
