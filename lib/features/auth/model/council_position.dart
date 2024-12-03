class CouncilPosition {
  final int? id;
  final int? councilId;
  final String? councilName;
  final int? userId;
  final String? fullName;
  final String? image;
  final String? email;
  final String? position;
  final bool? isLogin;
  final bool? grantAccess;
  final int? totalToDoTasks;
  final int? totalInProgressTasks;
  final int? totalCompletedTasks;
  final int? totalNeedsRevision;
  final int? totalRejected;

  CouncilPosition({
    this.id,
    this.councilId,
    this.councilName,
    this.userId,
    this.fullName,
    this.image,
    this.email,
    this.position,
    this.isLogin,
    this.grantAccess,
    this.totalToDoTasks,
    this.totalInProgressTasks,
    this.totalCompletedTasks,
    this.totalNeedsRevision,
    this.totalRejected,
   
  });

  // Factory constructor to create a CouncilPosition from a JSON object
  factory CouncilPosition.fromJson(Map<String, dynamic> json) {
    return CouncilPosition(
      id: json['id'],
      councilId: json['council_id'],
      councilName: json['council_name'],
      userId: json['user_id'],
      fullName: json['fullname'],
      image: json['image'],
      email: json['email'],
      position: json['position'],
      isLogin: json['is_login'],
      grantAccess: json['grant_access'],
      totalToDoTasks: json['total_to_do_tasks'],
      totalInProgressTasks: json['total_in_progress_tasks'],
      totalCompletedTasks: json['total_completed_tasks'],
      totalNeedsRevision: json['total_needs_revision'],
      totalRejected: json['total_rejected'],
    
    );
  }

  



  // Convert CouncilPosition object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'council_id': councilId,
      'council_name': councilName,
      'user_id': userId,
      'fullname': fullName,
      'image': image,
      'email': email,
      'position': position,
      'is_login': isLogin,
      'grant_access': grantAccess,
      'total_to_do_tasks': totalToDoTasks,
      'total_in_progress_tasks': totalInProgressTasks,
      'total_completed_tasks': totalCompletedTasks,
      'total_needs_revision': totalNeedsRevision,
      'total_rejected': totalRejected,
    
    };
  }

  // Convert CouncilPosition object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'council_id': councilId,
      'council_name': councilName,
      'user_id': userId,
      'fullname': fullName,
      'image': image,
      'email': email,
      'position': position,
      'is_login': isLogin,
      'grant_access': grantAccess,
      'total_to_do_tasks': totalToDoTasks,
      'total_in_progress_tasks': totalInProgressTasks,
      'total_completed_tasks': totalCompletedTasks,
      'total_needs_revision': totalNeedsRevision,
      'total_rejected': totalRejected,
     
    };
  }

  // Create CouncilPosition from Map
  factory CouncilPosition.fromMap(Map<String, dynamic> map) {
    return CouncilPosition(
      id: map['id'] != null ? map['id'] as int : null,
      councilId: map['council_id'] != null ? map['council_id'] as int : null,
      councilName: map['council_name'] != null ? map['council_name'] as String : null,
      userId: map['user_id'] != null ? map['user_id'] as int : null,
      fullName: map['fullname'] != null ? map['fullname'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      position: map['position'] != null ? map['position'] as String : null,
      isLogin: map['is_login'] != null ? map['is_login'] as bool : null,
      grantAccess: map['grant_access'] != null ? map['grant_access'] as bool : null,
      totalToDoTasks: map['total_to_do_tasks'] != null ? map['total_to_do_tasks'] as int : null,
      totalInProgressTasks: map['total_in_progress_tasks'] != null ? map['total_in_progress_tasks'] as int : null,
      totalCompletedTasks: map['total_completed_tasks'] != null ? map['total_completed_tasks'] as int : null,
      totalNeedsRevision: map['total_needs_revision'] != null ? map['total_needs_revision'] as int : null,
      totalRejected: map['total_rejected'] != null ? map['total_rejected'] as int : null,
     
    );
  }

  // Helper method for copying the object with new values
  CouncilPosition copyWith({
    int? id,
    int? councilId,
    String? councilName,
    int? userId,
    String? fullName,
    String? image,
    String? email,
    String? position,
    bool? isLogin,
    bool? grantAccess,
    int? totalToDoTasks,
    int? totalInProgressTasks,
    int? totalCompletedTasks,
    int? totalCompletedLateTasks,
    int? totalDueTasks,
    int? totalOnHoldTasks,
    int? totalCancelledTasks,
    int? totalReviewTasks,
    int? totalBlockedTasks,
  }) {
    return CouncilPosition(
      id: id ?? this.id,
      councilId: councilId ?? this.councilId,
      councilName: councilName ?? this.councilName,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      image: image ?? this.image,
      email: email ?? this.email,
      position: position ?? this.position,
      isLogin: isLogin ?? this.isLogin,
      grantAccess: grantAccess ?? this.grantAccess,
      totalToDoTasks: totalToDoTasks ?? this.totalToDoTasks,
      totalInProgressTasks: totalInProgressTasks ?? this.totalInProgressTasks,
      totalCompletedTasks: totalCompletedTasks ?? this.totalCompletedTasks,
      totalNeedsRevision: totalNeedsRevision ?? this.totalNeedsRevision,
      totalRejected: totalRejected ?? this.totalRejected,
     
    );
  }

  @override
  String toString() {
    return 'CouncilPosition(id: $id, councilId: $councilId, councilName: $councilName, userId: $userId, fullName: $fullName, image: $image,email: $email, position: $position, isLogin: $isLogin, grantAccess: $grantAccess, totalToDoTasks: $totalToDoTasks, totalInProgressTasks: $totalInProgressTasks, totalCompletedTasks: $totalCompletedTasks, totalNeedsRevision: $totalNeedsRevision, totalRejected: $totalRejected)';
  }

}
