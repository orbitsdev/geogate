import 'package:geogate/features/auth/model/user_details.dart';

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? email;
  
  final String? image;
  final UserDetails? userDetails;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
 
    this.image,
    this.userDetails,
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
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      fullName: map['full_name'],
      email: map['email'],
      image: map['image'],
      userDetails: map['user_details'] != null
          ? UserDetails.fromMap(map['user_details'])
          : null,
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
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
     
      'image': image,
      'user_details': userDetails?.toMap(),
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
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      image: image ?? this.image,
      userDetails: userDetails ?? this.userDetails,
    );
  }
}
