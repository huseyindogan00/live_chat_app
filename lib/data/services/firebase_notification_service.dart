import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:live_chat_app/ui/components/common/platform_sensitive_alert_dialog.dart';

class FirebaseNotificationService {
  Future<void> _settingsNotification() async {
    await FirebaseMessaging.instance.requestPermission(alert: true, sound: true, badge: true);
  }

  void connectNotification() async {
    //await Firebase.initializeApp();
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.subscribeToTopic('gazete');

    await _settingsNotification();
    /* FirebaseMessaging.onMessage.listen((event) { 
      
    }); */

    /* FirebaseMessaging.instance.getInitialMessage().then(
      (value) {
        print(value?.data.toString());
      },
    ); */
    FirebaseMessaging.instance.getToken().then((value) => print('Token : $value'));
  }

  /*  void sendMessageNotification(String message, String token) {
 
    _firebaseMessaging.sendMessage(collapseKey: token,data: <String,String>{'data':message},);
  }

  int _messageCount = 0;

  String constructFCMPayload(String? token) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#$_messageCount) was created via FCM!',
      },
    });
  } */
}
