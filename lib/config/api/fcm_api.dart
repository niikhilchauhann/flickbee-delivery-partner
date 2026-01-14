// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;

// final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

// final tokens = usersSnapshot.docs
//     .map((doc) => doc.data()['fcmToken'] as String?)
//     .where((token) => token != null)
//     .toList();

// Future<void> sendPushMessage(String token, String title, String body) async {
//   final serverKey = 'YOUR_SERVER_KEY'; // Get this from Firebase Console > Project Settings > Cloud Messaging tab

//   final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

//   final response = await http.post(
//     url,
//     headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$serverKey',
//     },
//     body: jsonEncode({
//       'to': token,
//       'notification': {
//         'title': title,
//         'body': body,
//       },
//     }),
//   );

//   if (response.statusCode == 200) {
//     print('✅ Message sent!');
//   } else {
//     print('❌ Failed to send: ${response.body}');
//   }
// }
