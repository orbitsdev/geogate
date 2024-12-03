class PositionOption
 {
  final int? id;
  final String? name;

  PositionOption
  ({
    this.id,
    this.name,
  });

  // Factory constructor to create PositionOption
  // from JSON
  factory PositionOption
  .fromJson(Map<String, dynamic> json) {
    return PositionOption
    (
      id: json['id'],
      name: json['name'],
    );
  }

  // Convert PositionOption
  // object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Create PositionOption
  // from Map
  factory PositionOption
  .fromMap(Map<String, dynamic> map) {
    return PositionOption
    (
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  // Helper method for copying the object with new values
  PositionOption
   copyWith({
    int? id,
    String? name,
  }) {
    return PositionOption
    (
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'PositionOption(id: $id, name: $name)';
  }
}
