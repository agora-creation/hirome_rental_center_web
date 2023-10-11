import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hirome_rental_center_web/common/style.dart';

class MessagingService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<String> getToken() async {
    String ret = '';
    try {
      ret = await messaging.getToken(vapidKey: kFcmKey) ?? '';
    } catch (e) {
      print(e.toString());
    }
    return ret;
  }
}
