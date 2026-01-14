import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String toUserId;
  final String body;
  final Timestamp timestamp;

  NotificationModel({
    required this.toUserId,
    required this.body,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      toUserId: json['toUserId'] as String,
      body: json['body'] as String,
      timestamp: (json['timestamp'] as Timestamp),
    );
  }

  Map<String, dynamic> toJson() {
    return {'toUserId': toUserId, 'body': body, 'timestamp': timestamp};
  }

  // tomap
  Map<String, dynamic> toMap() {
    return {'toUserId': toUserId, 'body': body, 'timestamp': timestamp};
  }
}
