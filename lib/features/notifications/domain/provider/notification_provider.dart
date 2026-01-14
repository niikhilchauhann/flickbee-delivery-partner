
// import '/features/notifications/domain/provider/notification_repository.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../auth/domain/repository/auth_provider.dart';
// import '../models/notification_model.dart';

// final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
//   return NotificationRepository();
// });
// final userNotificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
//   final user = ref.watch(userDataProvider).value;
//   if (user == null) return const Stream.empty();
  
//   final repo = ref.watch(notificationRepositoryProvider);
//   return repo.fetchUserNotifications(user.uid);
// });
