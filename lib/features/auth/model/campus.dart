class Campus {
  final int? id;
  final String? name;
  final num? latitude;
  final num? longitude;
  final num? radius;

  Campus({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.radius,
  });

  factory Campus.fromJson(Map<String, dynamic> json) {
    return Campus(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'] != null
          ? num.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? num.tryParse(json['longitude'].toString())
          : null,
      radius: json['radius'] != null
          ? num.tryParse(json['radius'].toString())
          : null,
    );
  }

  factory Campus.fromMap(Map<String, dynamic> map) {
    return Campus(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'] != null
          ? num.tryParse(map['latitude'].toString())
          : null,
      longitude: map['longitude'] != null
          ? num.tryParse(map['longitude'].toString())
          : null,
      radius: map['radius'] != null
          ? num.tryParse(map['radius'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
    };
  }

  Campus copyWith({
    int? id,
    String? name,
    num? latitude,
    num? longitude,
    num? radius,
  }) {
    return Campus(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
    );
  }
}
