// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../core/exports.dart';
// import '../models/notification_model.dart';

// class NotificationRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Fetch notifications for a specific user (from subcollection).
//   Stream<List<NotificationModel>> fetchUserNotifications(String userId) {
//     return _firestore
//         .collection('users')
//         .doc(userId)
//         .collection('notifications')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => NotificationModel.fromJson(doc.data()))
//               .toList(),
//         );
//   }

//   /// Send a notification to a specific user.
//   Future<void> sendNotification({
//     required String toUserId,
//     required String body,
//     NotificationType? type, 
//   }) async {
//     final notification = {
//       'toUserId': toUserId,
//       'body': body,
//       'type': type?.name ?? NotificationType.general.name,
//       'timestamp': FieldValue.serverTimestamp(),
//     };

//     await _firestore
//         .collection('users')
//         .doc(toUserId)
//         .collection('notifications')
//         .add(notification);
//   }
// }
