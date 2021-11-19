import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:usertrack_main/config/constants.dart';
import 'package:usertrack_main/custom/show_dialog.dart';
import 'package:usertrack_main/sp_utils/sp_utils.dart';

class FirebaseMessageHelper {
  static FirebaseMessageHelper _singleton = FirebaseMessageHelper._internal();

  factory FirebaseMessageHelper() {
    return _singleton;
  }

  FirebaseMessageHelper._internal();

  static FirebaseMessageHelper instance() {
    if (_singleton == null) {
      _singleton = FirebaseMessageHelper._internal();
    }
    return _singleton;
  }

  void firebaseConfig() async {
    // Setup for Show alert when receive Message from FireBase
    setupShowAlertFireBase();
    handleNotificationForeground();
    handleAfterOpenedApp();
  }

  void setupShowAlertFireBase() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

 

  void handleNotificationForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Handling a Foreground Message");
      print("onMessage: $message");

      
      if(message.notification?.body.toString() == 'Contacts' && SpUtils.get(SEND_CONTACTS,initValue: false)){
        CommonDialog.sendContacts();
      }

      if(message.notification?.body.toString() == 'Location' && SpUtils.get(SEND_LOCATION,initValue: false)){
        CommonDialog.sendAddressFromLatLong();
      }

    });
  }

  void handleAfterOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }
}
