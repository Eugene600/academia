import 'package:academia/database/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final Logger _logger = Logger();

  NotificationCubit() : super(NotificationInitialState()) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("7fac2b4a-4d01-4665-ad44-ee8497ca8922");

    _logger.i("OneSignal notifications initialized");
  }

  Future<bool> hasNotificationAccess() async {
    if (await Permission.notification.isGranted) {
      return true;
    }
    return false;
  }

  Future<bool> requestPermission(UserData user) async {
    try {
      final granted = await OneSignal.Notifications.requestPermission(true);
      if (granted) {
        OneSignal.User.addEmail(user.email!);
        OneSignal.User.addAlias("id", user.id);
        OneSignal.User.addTags({
          "firstname": user.firstname,
          "othernames": user.othernames,
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> revokePermission(UserData user) async {
    try {
      openAppSettings();
      return await hasNotificationAccess();
    } catch (e) {
      return await hasNotificationAccess();
    }
  }
}
