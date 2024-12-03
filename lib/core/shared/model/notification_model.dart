
import 'dart:convert';




class NotificationModel {
  String? id;
  int? notifiable_id;
  String? read_at;
  String? created_at;
  NotificationMessage? data;
  NotificationModel({
    this.id,
    this.notifiable_id,
    this.read_at,
    this.created_at,
    this.data,
  });



  NotificationModel copyWith({
    String? id,
    int? notifiable_id,
    String? read_at,
    String? created_at,
     NotificationMessage? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      notifiable_id: notifiable_id ?? this.notifiable_id,
      read_at: read_at ?? this.read_at,
      created_at: created_at ?? this.created_at,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'notifiable_id': notifiable_id,
      'read_at': read_at,
      'created_at': created_at,
      'data': data?.toMap(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] != null ? map['id'] as String : null,
      notifiable_id: map['notifiable_id'] != null ? map['notifiable_id'] as int : null,
      read_at: map['read_at'] != null ? map['read_at'] as String : null,
      created_at: map['created_at'] != null ? map['created_at'] as String : null,
       data: map['data'] != null ? NotificationMessage.fromMap(map['data'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Notification(id: $id, notifiable_id: $notifiable_id, read_at: $read_at, created_at: $created_at data: $data)';

  
}

class NotificationMessage {
  int? modelId;
  String? body;
  String? title;
  NotificationMessage({
    this.body,
    this.modelId,
    this.title,
  });
  
 


  NotificationMessage copyWith({
    String? message,
    int? modelId,
    String? title,
  }) {
    return NotificationMessage(
      body: message ?? this.body,
      modelId: modelId ?? this.modelId,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'body': body,
      'model_id': modelId,
      'title': title,
    };
  }

  factory NotificationMessage.fromMap(Map<String, dynamic> map) {
    return NotificationMessage(
      body: map['body'] != null ? map['body'] as String : null,
      modelId: map['model_id'] != null ? map['model_id'] as int : null,
      title: map['title'] != null ? map['title'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationMessage.fromJson(String source) => NotificationMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NotificationMessage(body: $body, modelId: $modelId, title: $title)';

}
